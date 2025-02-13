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
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private let initialItem: Driver<Item>
    
    private lazy var collectionsManager = CollectionsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(item: Item) {
        self.initialItem = BehaviorRelay(value: item).asDriver()
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
        let isWardrobe: Driver<Bool>
        let isCustom: Driver<Bool>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let item = makeItem(
            initialItem: initialItem,
            didTapWardrobe: input.didTapWardrobe
        )
        
        return Output(
            elements: makeElements(item: item),
            isWardrobe: item.map { $0.isWardrobe },
            isCustom: item.map { $0.isCustom },
            route: makeRoute(
                didTapDelete: input.didTapDelete,
                didConfirmDelete: input.didConfirmDelete,
                item: item
            )
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
    
    // TODO: obtain item request
    func makeItem(
        initialItem: Driver<Item>,
        didTapWardrobe: Signal<Bool>
    ) -> Driver<Item> {
        let wardrobe = didTapWardrobe
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(initialItem) { ($0, $1.id) }
            .flatMapLatest { [weak self] isWardrobe, id -> Driver<Item> in
                guard let self else { return .never() }
                
                func source() -> Single<Item> {
                    let item = isWardrobe ? collectionsManager.removeWardrobe(itemId: id) : collectionsManager.addWardrobe(itemId: id)
                    
                    return item
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
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(initialItem, wardrobe)
    }
    
    func makeRoute(
        didTapDelete: Signal<Void>,
        didConfirmDelete: Signal<Void>,
        item: Driver<Item>
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
        
        return Driver
            .merge(confirmDelete, delete)
    }
}
