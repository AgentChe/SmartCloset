//
//  ItemViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 04.02.2025.
//

import RxSwift
import RxCocoa

final class ItemViewModel {
    enum Route {
        case close
        case confirmDelete(Item)
        case paygate
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var activity = RxActivityIndicator()
    
    private let itemId: Driver<String>
    
    private lazy var collectionsManager = CollectionsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(item: Item) {
        self.itemId = BehaviorRelay(value: item.id).asDriver()
    }
}

// MARK: Public
extension ItemViewModel {
    struct Input {
        let didTapWardrobe: Signal<Bool>
        let didTapDelete: Signal<Void>
        let didConfirmDelete: Signal<Void>
    }
    
    struct Output {
        let elements: Driver<[ItemTableElement]>
        let wardrobeAvailable: Driver<Bool>
        let isWardrobe: Driver<Bool>
        let deleteAvailable: Driver<Bool>
        let route: Driver<Route>
        let activity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let item = makeItem(itemId: itemId)
        
        return Output(
            elements: makeElements(item: item),
            wardrobeAvailable: makeWardribeAvailable(item: item),
            isWardrobe: makeIsWardrobe(
                item: item,
                didTapWardrobe: input.didTapWardrobe
            ),
            deleteAvailable: makeDeleteAvailable(item: item),
            route: makeRoute(
                didTapDelete: input.didTapDelete,
                didConfirmDelete: input.didConfirmDelete,
                item: item,
                didTapWardrobe: input.didTapWardrobe
            ),
            activity: activity.asDriver()
        )
    }
}

// MARK: Private
private extension ItemViewModel {
    func makeElements(item: Driver<Item>) -> Driver<[ItemTableElement]> {
        item.map { item -> [ItemTableElement] in
            var result = [ItemTableElement]()
            
            result.append(.image(item.image))
            
            if let category = item.category {
                result.append(.textField("Item.Category".localized, category))
            }
            
            if let type = item.type {
                result.append(.textField("Item.Type".localized, type))
            }
            
            if let color = item.color {
                result.append(.color(color))
            }
            
            if let material = item.material {
                result.append(.textField("Item.Fabric".localized, material))
            }
            
            if let comments = item.comments {
                result.append(.textField("Item.Comments".localized, comments))
            }
            
            return result
        }
    }
    
    func makeWardribeAvailable(item: Driver<Item> ) -> Driver<Bool> {
        item
            .map { !$0.isCustom }
            .startWith(false)
    }
    
    func makeIsWardrobe(
        item: Driver<Item>,
        didTapWardrobe: Signal<Bool>
    ) -> Driver<Bool> {
        let initial = item
            .map { $0.isWardrobe }
        
        let update = didTapWardrobe
            .filter { _ in SessionManager().hasActiveSubscriptions() }
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(item) { ($0, $1.id) }
            .flatMapLatest { [weak self] isWardrobe, id -> Driver<Bool> in
                guard let self else { return .never() }

                func source() -> Single<Bool> {
                    if isWardrobe {
                        return collectionsManager
                            .removeWardrobe(itemId: id)
                            .map { result -> Bool in
                                guard result.success else {
                                    throw ContentError(.notContent)
                                }

                                return false
                            }
                    } else {
                        return collectionsManager
                            .addWardrobe(itemId: id)
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
    
    func makeDeleteAvailable(item: Driver<Item>) -> Driver<Bool> {
        item
            .map { $0.isCustom }
            .startWith(false)
    }
    
    func makeRoute(
        didTapDelete: Signal<Void>,
        didConfirmDelete: Signal<Void>,
        item: Driver<Item>,
        didTapWardrobe: Signal<Bool>
    ) -> Driver<Route> {
        let confirmDelete = didTapDelete
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(item)
            .map { Route.confirmDelete($0) }
        
        let delete = didConfirmDelete
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(item)
            .flatMapLatest { [weak self] item -> Driver<Route> in
                guard let self else { return .never() }
                
                func source() -> Single<Void> {
                    collectionsManager
                        .deleteItem(id: item.id)
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
        
        let paygate = didTapWardrobe
            .filter { _ in !SessionManager().hasActiveSubscriptions() }
            .map { _ in Route.paygate }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(confirmDelete, delete, paygate)
    }
    
    func makeItem(itemId: Driver<String>) -> Driver<Item> {
        itemId
            .flatMapLatest { [weak self] id -> Driver<Item> in
                guard let self else { return .never() }
                
                func source() -> Single<Item> {
                    collectionsManager
                        .obtainItem(id: id)
                        .map { item -> Item in
                            guard let item else {
                                throw ContentError(.notContent)
                            }
                            
                            return item
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
