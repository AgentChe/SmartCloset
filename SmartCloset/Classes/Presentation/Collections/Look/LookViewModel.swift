//
//  LookViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 05.02.2025.
//

import RxSwift
import RxCocoa

final class LookViewModel {
    enum Route {
        case close
        case openItem(Item)
        case confirmDelete(Look)
    }
    
    enum Action {
        case share
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var activity = RxActivityIndicator()
    
    private let lookId: Driver<String>
    
    private lazy var collectionsManager = CollectionsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(look: Look) {
        self.lookId = BehaviorRelay(value: look.id).asDriver()
    }
}

// MARK: Public
extension LookViewModel {
    struct Input {
        let didSelectItem: Signal<Item>
        let didTapFavorite: Signal<Bool>
        let didTapShare: Signal<Void>
        let didTapWardrobe: Signal<Bool>
        let didTapDelete: Signal<Void>
        let didConfirmDelete: Signal<Void>
    }
    
    struct Output {
        let itemsElements: Driver<[Item]>
        let route: Driver<Route>
        let isFavorite: Driver<Bool>
        let look: Driver<Look>
        let action: Driver<Action>
        let wardrobeAvailable: Driver<Bool>
        let isWardrobe: Driver<Bool>
        let deleteAvailable: Driver<Bool>
        let activity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let look = makeLook(lookId: lookId)
        
        return Output(
            itemsElements: makeItemsElements(look: look),
            route: makeRoute(
                didSelectItem: input.didSelectItem,
                didTapDelete: input.didTapDelete,
                didConfirmDelete: input.didConfirmDelete,
                look: look
            ),
            isFavorite: makeIsFavorite(
                look: look,
                didTapFavorite: input.didTapFavorite
            ),
            look: look,
            action: makeAction(didTapShare: input.didTapShare),
            wardrobeAvailable: makeWardribeAvailable(look: look),
            isWardrobe: makeIsWardrobe(
                look: look,
                didTapWardrobe: input.didTapWardrobe
            ),
            deleteAvailable: makeDeleteAvailable(look: look),
            activity: activity.asDriver()
        )
    }
}

// MARK: Private
private extension LookViewModel {
    func makeItemsElements(look: Driver<Look>) -> Driver<[Item]> {
        look
            .map { look -> [Item] in
                [
                    look.top,
                    look.bottom,
                    look.shoes,
                    look.bags,
                    look.accessories
                ].compactMap { $0 }
            }
    }
    
    func makeWardribeAvailable(look: Driver<Look> ) -> Driver<Bool> {
        look
            .map { !$0.isCustom }
            .startWith(false)
    }
    
    func makeIsWardrobe(
        look: Driver<Look>,
        didTapWardrobe: Signal<Bool>
    ) -> Driver<Bool> {
        let initial = look
            .map { $0.isWardrobe }
        
        let update = didTapWardrobe
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(look) { ($0, $1.id) }
            .flatMapLatest { [weak self] isWardrobe, id -> Driver<Bool> in
                guard let self else { return .never() }

                func source() -> Single<Bool> {
                    if isWardrobe {
                        return collectionsManager
                            .removeWardrobe(lookId: id)
                            .map { result -> Bool in
                                guard result.success else {
                                    throw ContentError(.notContent)
                                }

                                return false
                            }
                    } else {
                        return collectionsManager
                            .addWardrobe(lookId: id)
                            .map { item -> Bool in
                                guard item != nil else {
                                    throw ContentError(.notContent)
                                }
                                
                                return true
                            }
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
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(initial, update)
    }
    
    func makeDeleteAvailable(look: Driver<Look>) -> Driver<Bool> {
        look
            .map { $0.isCustom }
            .startWith(false)
    }
    
    func makeRoute(
        didSelectItem: Signal<Item>,
        didTapDelete: Signal<Void>,
        didConfirmDelete: Signal<Void>,
        look: Driver<Look>
    ) -> Driver<Route> {
        let openItem = didSelectItem
            .map { Route.openItem($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let confirmDelete = didTapDelete
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(look)
            .map { Route.confirmDelete($0) }
        
        let delete = didConfirmDelete
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(look)
            .flatMapLatest { [weak self] look -> Driver<Route> in
                guard let self else { return .never() }
                
                func source() -> Single<Void> {
                    collectionsManager
                        .deleteLook(id: look.id)
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
                    .map { Route.close }
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(openItem, confirmDelete, delete)
    }
    
    func makeIsFavorite(
        look: Driver<Look>,
        didTapFavorite: Signal<Bool>
    ) -> Driver<Bool> {
        let initial = look
            .map { $0.isFavorite }
        
        let changeFavorite = didTapFavorite
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(look) { ($0, $1) }
            .flatMapLatest { [weak self] marked, look -> Driver<Bool> in
                guard let self else { return .never() }
                
                func source() -> Single<Bool> {
                    let id = look.id
                    
                    let single = marked
                        ? collectionsManager.removeFavorite(id: id, tab: .looks)
                        : collectionsManager.addFavorite(id: id, tab: .looks)
                    
                    return single
                        .flatMap { result -> Single<Bool> in
                            guard result.success else { return .error(NetworkError(.serverNotAvailable)) }
                            
                            return .just(!marked)
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
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(initial, changeFavorite)
    }
    
    func makeAction(didTapShare: Signal<Void>) -> Driver<Action> {
        let share = didTapShare
            .map { Action.share }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(share)
    }
    
    func makeLook(lookId: Driver<String>) -> Driver<Look> {
        lookId
            .flatMapLatest { [weak self] id -> Driver<Look> in
                guard let self else { return .never() }
                
                func source() -> Single<Look> {
                    collectionsManager
                        .obtainLook(id: id)
                        .map { look -> Look in
                            guard let look else {
                                throw ContentError(.notContent)
                            }
                            
                            return look
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
