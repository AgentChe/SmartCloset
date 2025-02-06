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
        case openItem(Item)
    }
    
    enum Action {
        case share
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private let look: Driver<Look>
    
    private lazy var collectionsManager = CollectionsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(look: Look) {
        self.look = BehaviorRelay(value: look).asDriver()
    }
}

// MARK: Public
extension LookViewModel {
    struct Input {
        let didSelectItem: Signal<Item>
        let didTapFavorite: Signal<Bool>
        let didTapShare: Signal<Void>
    }
    
    struct Output {
        let itemsElements: Driver<[Item]>
        let route: Driver<Route>
        let isFavorite: Driver<Bool>
        let look: Driver<Look>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            itemsElements: makeItemsElements(look: look),
            route: makeRoute(didSelectItem: input.didSelectItem),
            isFavorite: makeIsFavorite(
                look: look,
                didTapFavorite: input.didTapFavorite
            ),
            look: look,
            action: makeAction(didTapShare: input.didTapShare)
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
    
    func makeRoute(didSelectItem: Signal<Item>) -> Driver<Route> {
        let openItem = didSelectItem
            .map { Route.openItem($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(openItem)
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
