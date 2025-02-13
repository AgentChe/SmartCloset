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
    
    private let initialLook: Driver<Look>
    
    private lazy var collectionsManager = CollectionsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(look: Look) {
        self.initialLook = BehaviorRelay(value: look).asDriver()
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
        let isWardrobe: Driver<Bool>
        let isCustom: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let look = makeLook(
            initialLook: initialLook,
            didTapWardrobe: input.didTapWardrobe
        )
        
        return Output(
            itemsElements: makeItemsElements(look: initialLook),
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
            isWardrobe: look.map { $0.isWardrobe },
            isCustom: look.map { $0.isCustom }
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
    
    // TODO: obtain look request
    func makeLook(
        initialLook: Driver<Look>,
        didTapWardrobe: Signal<Bool>
    ) -> Driver<Look> {
        let wardrobe = didTapWardrobe
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(initialLook) { ($0, $1.id) }
            .flatMapLatest { [weak self] isWardrobe, id -> Driver<Look> in
                guard let self else { return .never() }
                
                func source() -> Single<Look> {
                    let look = isWardrobe ? collectionsManager.removeWardrobe(lookId: id) : collectionsManager.addWardrobe(lookId: id)
                    
                    return look
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
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(initialLook, wardrobe)
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
}
