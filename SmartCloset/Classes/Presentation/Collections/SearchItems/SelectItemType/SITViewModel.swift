//
//  SITViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 02.02.2025.
//

import RxSwift
import RxCocoa

final class SITViewModel {
    enum Route {
        case dismiss
        case complete(ItemCategory, ItemType)
    }
    
    private let itemCategory: Driver<ItemCategory>
    private let initialItemType: Driver<ItemType?>
    
    init(itemCategory: ItemCategory, itemType: ItemType?) {
        self.itemCategory = BehaviorRelay(value: itemCategory).asDriver()
        self.initialItemType = BehaviorRelay(value: itemType).asDriver()
    }
}

// MARK: Public
extension SITViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didTapSave: Signal<Void>
    }
    
    struct Output {
        let elements: Driver<[SITTableElement]>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let elements = makeElements(
            itemCategory: itemCategory,
            initialItemType: initialItemType
        )
        
        return Output(
            elements: elements,
            route: makeRoute(
                didTapClose: input.didTapClose,
                didTapSave: input.didTapSave,
                elements: elements,
                itemCategory: itemCategory
            )
        )
    }
}

// MARK: Private
private extension SITViewModel {
    func makeElements(
        itemCategory: Driver<ItemCategory>,
        initialItemType: Driver<ItemType?>
    ) -> Driver<[SITTableElement]> {
        Driver
            .combineLatest(itemCategory, initialItemType)
            .map { itemCategory, initialItemType -> [SITTableElement] in
                ItemCategory.TypesFabric().list(for: itemCategory)
                    .map { itemType -> SITTableElement in
                        SITTableElement(
                            itemType: itemType,
                            marked: itemType == initialItemType
                        )
                    }
            }
    }
    
    func makeRoute(
        didTapClose: Signal<Void>,
        didTapSave: Signal<Void>,
        elements: Driver<[SITTableElement]>,
        itemCategory: Driver<ItemCategory>
    ) -> Driver<Route> {
        let dismiss = didTapClose
            .map { Route.dismiss }
            .asDriver(onErrorDriveWith: .never())
        
        let complete = didTapSave
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(itemCategory)
            .withLatestFrom(elements) { ($0, $1) }
            .compactMap { itemCategory, elements -> (ItemCategory, ItemType)? in
                guard let itemType = elements.first(where: { $0.marked })?.itemType else { return nil }
                return (itemCategory, itemType)
            }
            .map { Route.complete($0.0, $0.1) }
        
        return Driver
            .merge(dismiss, complete)
    }
}
