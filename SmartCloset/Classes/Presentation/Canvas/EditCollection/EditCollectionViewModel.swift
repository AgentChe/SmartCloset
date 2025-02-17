//
//  EditCollectionViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 10.02.2025.
//

import RxSwift
import RxCocoa

final class EditCollectionViewModel {
    enum Route {
        case dismiss
        case openLook(Look)
        case addLook([String])
        case confirmDeleteLook(Look)
        case confirmDeleteCollection(Collection)
        case deleted
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private let collection: Driver<Collection>
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var collectionsManager = CollectionsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(collection: Collection) {
        self.collection = BehaviorRelay(value: collection).asDriver()
    }
}

// MARK: Public
extension EditCollectionViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didTapSave: Signal<Void>
        let didTapDeleteCollection: Signal<Void>
        let didConfirmDeleteCollection: Signal<Void>
        let didTapDeleteLook: Signal<Look>
        let didConfirmDeleteLook: Signal<Look>
        let didTapAddLook: Signal<Void>
        let didAddedLooks: Signal<[Look]>
        let didSelectLook: Signal<Look>
        let didInputName: Signal<String?>
    }
    
    struct Output {
        let route: Driver<Route>
        let initialName: Driver<String>
        let activity: Driver<Bool>
        let elements: Driver<[ECCollectionElement]>
        let canSave: Driver<Bool>
        let deleteAvailable: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let looks = makeLooks(
            collection: collection,
            didConfirmDeleteLook: input.didConfirmDeleteLook,
            didAddedLooks: input.didAddedLooks
        )
        let name = makeName(
            collection: collection,
            didInputName: input.didInputName
        )
        
        return Output(
            route: makeRoute(
                didTapClose: input.didTapClose,
                didTapAddLook: input.didTapAddLook,
                didSelectLook: input.didSelectLook,
                didTapDeleteLook: input.didTapDeleteLook,
                didTapDeleteCollection: input.didTapDeleteCollection,
                collection: collection,
                didConfirmDeleteCollection: input.didConfirmDeleteCollection,
                looks: looks,
                name: name,
                didTapSave: input.didTapSave
            ),
            initialName: collection.map { $0.name },
            activity: activity.asDriver(),
            elements: makeElements(looks: looks),
            canSave: makeCanSave(
                looks: looks,
                name: name
            ),
            deleteAvailable: makeDeleteAvailable(collection: collection)
        )
    }
}

// MARK: Private
private extension EditCollectionViewModel {
    func makeRoute(
        didTapClose: Signal<Void>,
        didTapAddLook: Signal<Void>,
        didSelectLook: Signal<Look>,
        didTapDeleteLook: Signal<Look>,
        didTapDeleteCollection: Signal<Void>,
        collection: Driver<Collection>,
        didConfirmDeleteCollection: Signal<Void>,
        looks: Driver<[Look]>,
        name: Driver<String>,
        didTapSave: Signal<Void>
    ) -> Driver<Route> {
        let dismiss = didTapClose
            .map { Route.dismiss }
            .asDriver(onErrorDriveWith: .never())
        
        let addLook = didTapAddLook
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(looks)
            .map { Route.addLook($0.map { $0.id }) }
        
        let openLook = didSelectLook
            .map { Route.openLook($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let confirmDeleteLook = didTapDeleteLook
            .map { Route.confirmDeleteLook($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let confirmDeleteCollection = didTapDeleteCollection
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(collection)
            .map { Route.confirmDeleteCollection($0) }
        
        let deleted = didConfirmDeleteCollection
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(collection)
            .flatMapLatest { [weak self] collection -> Driver<Route> in
                guard let self else { return .never() }
                
                func source() -> Single<Void> {
                    collectionsManager
                        .deleteCollection(id: collection.id)
                        .map { result -> Void in
                            guard result.success else {
                                throw ContentError(.notContent)
                            }
                            
                            return Void()
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .trackActivity(activity)
                    .map { Route.deleted }
                    .asDriver(onErrorDriveWith: .never())
            }
        
        let save = didTapSave
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(collection.map { $0.id })
            .withLatestFrom(looks) { ($0, $1) }
            .withLatestFrom(name) { ($0.0, $0.1, $1) }
            .flatMapLatest { [weak self] id, looks, name -> Driver<Route> in
                guard let self else { return .never() }
                
                func source() -> Single<Void> {
                    collectionsManager
                        .editCollection(id: id, name: name, looks: looks.map { $0.id })
                        .map { collection -> Void in
                            guard collection != nil else {
                                throw ContentError(.notContent)
                            }
                            
                            return Void()
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .trackActivity(activity)
                    .map { Route.dismiss }
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(
                dismiss,
                addLook,
                openLook,
                confirmDeleteLook,
                confirmDeleteCollection,
                deleted,
                save
            )
    }
    
    func makeElements(looks: Driver<[Look]>) -> Driver<[ECCollectionElement]> {
        looks
            .map { looks -> [ECCollectionElement] in
                [.addLook] + looks.map { .look($0) }
            }
    }
    
    func makeLooks(
        collection: Driver<Collection>,
        didConfirmDeleteLook: Signal<Look>,
        didAddedLooks: Signal<[Look]>
    ) -> Driver<[Look]> {
        enum Action {
            case append([Look])
            case delete(Look)
        }
        
        let delete = didConfirmDeleteLook
            .map { Action.delete($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let append = didAddedLooks
            .map { Action.append($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return collection
            .flatMapLatest { collection -> Driver<[Look]> in
                Driver
                    .merge(delete, append)
                    .scan(collection.looks) { looks, action -> [Look] in
                        switch action {
                        case .append(let newLooks):
                            return looks + newLooks
                        case .delete(let look):
                            var result = looks
                            result.removeAll(where: { $0.id == look.id })
                            return result
                        }
                    }
                    .startWith(collection.looks)
            }
    }
    
    func makeCanSave(
        looks: Driver<[Look]>,
        name: Driver<String>
    ) -> Driver<Bool> {
        Driver
            .combineLatest(looks, name) { looks, name -> Bool in
                !looks.isEmpty && !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
    }
    
    func makeDeleteAvailable(collection: Driver<Collection>) -> Driver<Bool> {
        collection
            .map { $0.isCustom }
            .startWith(false)
    }
    
    func makeName(
        collection: Driver<Collection>,
        didInputName: Signal<String?>
    ) -> Driver<String> {
        Driver
            .merge(
                collection.map { $0.name },
                didInputName
                    .skip(1)
                    .map { $0 ?? "" }
                    .asDriver(onErrorDriveWith: .never())
            )
    }
}
