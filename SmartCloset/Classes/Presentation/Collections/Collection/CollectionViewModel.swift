//
//  CollectionViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 10.02.2025.
//

import RxSwift
import RxCocoa

final class CollectionViewModel {
    enum Route {
        case edit(Collection)
        case openLook(Look)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var activity = RxActivityIndicator()
    
    private let collectionId: Driver<String>
    
    private lazy var collectionsManager = CollectionsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(collection: Collection) {
        self.collectionId = BehaviorRelay(value: collection.id).asDriver()
    }
}

// MARK: Public
extension CollectionViewModel {
    struct Input {
        let didTapEdit: Signal<Void>
        let didSelectLook: Signal<Look>
    }
    
    struct Output {
        let route: Driver<Route>
        let elements: Driver<[Look]>
        let name: Driver<String>
        let activity: Driver<Bool>
        let editAvailable: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let collection = makeCollection(collectionId: collectionId)
        
        return Output(
            route: makeRoute(
                didTapEdit: input.didTapEdit,
                collection: collection,
                didSelectLook: input.didSelectLook
            ),
            elements: collection.map { $0.looks },
            name: collection.map { $0.name },
            activity: activity.asDriver(),
            editAvailable: makeEditAvailable(collection: collection)
        )
    }
}

// MARK: Private
private extension CollectionViewModel {
    func makeRoute(
        didTapEdit: Signal<Void>,
        collection: Driver<Collection>,
        didSelectLook: Signal<Look>
    ) -> Driver<Route> {
        let edit = didTapEdit
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(collection)
            .map { Route.edit($0) }
        
        let openLook = didSelectLook
            .map { Route.openLook($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(edit, openLook)
    }
    
    func makeEditAvailable(collection: Driver<Collection>) -> Driver<Bool> {
        collection
            .map { $0.isCustom }
            .startWith(false)
    }
    
    func makeCollection(collectionId: Driver<String>) -> Driver<Collection> {
        let triggerUpdate = CollectionsMediator.shared
            .collectionEdited
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(collectionId) { ($0, $1) }
            .compactMap { edited, id -> String? in
                edited.id == id ? id : nil
            }
        
        let trigger = Driver
            .merge(collectionId, triggerUpdate)
        
        return trigger
            .flatMapLatest { [weak self] id -> Driver<Collection> in
                guard let self else { return .never() }
                
                func source() -> Single<Collection> {
                    collectionsManager
                        .obtainCollection(id: id)
                        .map { collection -> Collection in
                            guard let collection else {
                                throw ContentError(.notContent)
                            }
                            
                            return collection
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
                    .asDriver(onErrorDriveWith: .never())
            }
    }
}
