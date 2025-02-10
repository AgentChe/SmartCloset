//
//  CreateLookViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 07.02.2025.
//

import RxSwift
import RxCocoa

final class CreateLookViewModel {
    enum Elements {
        case setup([CLItemsCollectionElement])
        case append([CLItemsCollectionElement])
    }
    
    enum Route {
        case close
        case selectItem(ItemCategory)
        case createLook(CreateLookViewController.LookItems)
    }
    
    private let inputData: Driver<CreateLookViewController.InputData?>
    
    private lazy var collectionsManager = CollectionsManager()
    
    init(inputData: CreateLookViewController.InputData?) {
        self.inputData = BehaviorRelay(value: inputData).asDriver()
    }
}

// MARK: Public
extension CreateLookViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didTapGenerate: Signal<Void>
        let didSelectItem: Signal<(ItemCategory, Item?)>
        let didSelectItemCategory: Signal<ItemCategory>
        let didScrollToLast: Signal<ItemCategory>
    }
    
    struct Output {
        let route: Driver<Route>
        let canGenerateLook: Driver<Bool>
        let topsElements: Driver<Elements>
        let bottomsElements: Driver<Elements>
        let shoesElements: Driver<Elements>
        let bagsElements: Driver<Elements>
        let accessoriesElements: Driver<Elements>
    }
    
    func configure(input: Input) -> Output {
        let selectedTopItem = makeSelectedItem(
            inputData: inputData,
            didSelectItem: input.didSelectItem,
            equalItemCategory: .tops
        )
        let selectedBottomsItem = makeSelectedItem(
            inputData: inputData,
            didSelectItem: input.didSelectItem,
            equalItemCategory: .bottoms
        )
        let selectedShoesItem = makeSelectedItem(
            inputData: inputData,
            didSelectItem: input.didSelectItem,
            equalItemCategory: .shoes
        )
        let selectedBagsItem = makeSelectedItem(
            inputData: inputData,
            didSelectItem: input.didSelectItem,
            equalItemCategory: .bags
        )
        let selectedAccessoriesItem = makeSelectedItem(
            inputData: inputData,
            didSelectItem: input.didSelectItem,
            equalItemCategory: .accessories
        )
        let lookItems = makeLookItems(
            selectedTopItem: selectedTopItem,
            selectedBottomsItem: selectedBottomsItem,
            selectedShoesItem: selectedShoesItem,
            selectedBagsItem: selectedBagsItem,
            selectedAccessoriesItem: selectedAccessoriesItem
        )
        
        return Output(
            route: makeRoute(
                didTapClose: input.didTapClose,
                didSelectItemCategory: input.didSelectItemCategory,
                didTapGenerate: input.didTapGenerate,
                lookItems: lookItems
            ),
            canGenerateLook: makeCanGenerateLook(lookItems: lookItems),
            topsElements: makeElements(
                selectedItem: selectedTopItem,
                didScrollToLast: input.didScrollToLast,
                itemCategory: .tops
            ),
            bottomsElements:  makeElements(
                selectedItem: selectedBottomsItem,
                didScrollToLast: input.didScrollToLast,
                itemCategory: .bottoms
            ),
            shoesElements:  makeElements(
                selectedItem: selectedShoesItem,
                didScrollToLast: input.didScrollToLast,
                itemCategory: .shoes
            ),
            bagsElements:  makeElements(
                selectedItem: selectedBagsItem,
                didScrollToLast: input.didScrollToLast,
                itemCategory: .bags
            ),
            accessoriesElements:  makeElements(
                selectedItem: selectedAccessoriesItem,
                didScrollToLast: input.didScrollToLast,
                itemCategory: .accessories
            )
        )
    }
}

// MARK: Private
private extension CreateLookViewModel {
    enum ElementsMode: Equatable {
        case empty
        case list(Item)
    }
    
    func makeRoute(
        didTapClose: Signal<Void>,
        didSelectItemCategory: Signal<ItemCategory>,
        didTapGenerate: Signal<Void>,
        lookItems: Driver<CreateLookViewController.LookItems>
    ) -> Driver<Route> {
        let close = didTapClose
            .map { Route.close }
            .asDriver(onErrorDriveWith: .never())
        
        let selectItem = didSelectItemCategory
            .map { Route.selectItem($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let createLook = didTapGenerate
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(lookItems)
            .map { Route.createLook($0) }
        
        return Driver
            .merge(close, selectItem, createLook)
    }
    
    func makeLookItems(
        selectedTopItem: Driver<Item?>,
        selectedBottomsItem: Driver<Item?>,
        selectedShoesItem: Driver<Item?>,
        selectedBagsItem: Driver<Item?>,
        selectedAccessoriesItem: Driver<Item?>
    ) -> Driver<CreateLookViewController.LookItems> {
        Driver
            .combineLatest(
                selectedTopItem,
                selectedBottomsItem,
                selectedShoesItem,
                selectedBagsItem,
                selectedAccessoriesItem
            ) { tops, bottoms, shoes, bags, accessories -> CreateLookViewController.LookItems in
                CreateLookViewController.LookItems(
                    tops: tops,
                    bottoms: bottoms,
                    shoes: shoes,
                    bags: bags,
                    accessories: accessories
                )
            }
    }
    
    func makeSelectedItem(
        inputData: Driver<CreateLookViewController.InputData?>,
        didSelectItem: Signal<(ItemCategory, Item?)>,
        equalItemCategory: ItemCategory
    ) -> Driver<Item?> {
        Driver
            .merge(
                didSelectItem
                    .asDriver(onErrorDriveWith: .never())
                    .filter { $0.0 == equalItemCategory }
                    .compactMap { $1 },
                inputData
                    .filter { $0?.0 == equalItemCategory }
                    .compactMap { $0?.1 }
            )
            .startWith(nil)
    }

    func makeCanGenerateLook(lookItems: Driver<CreateLookViewController.LookItems>) -> Driver<Bool> {
        lookItems.map { lookItems -> Bool in
            let hasTop = lookItems.tops != nil
            let hasBottoms = lookItems.bottoms != nil
            let hasShoes = lookItems.shoes != nil
            let hasBags = lookItems.bags != nil
            let hasAccessories = lookItems.accessories != nil
            return [hasTop, hasBottoms, hasShoes, hasBags, hasAccessories].contains(true)
        }
    }
    
    func makeElements(
        selectedItem: Driver<Item?>,
        didScrollToLast: Signal<ItemCategory>,
        itemCategory: ItemCategory
    ) -> Driver<Elements> {
        let mode = selectedItem
            .map { item -> ElementsMode in
                guard let item else { return .empty }
                return .list(item)
            }
            .distinctUntilChanged()
        
        return mode
            .flatMapLatest { [weak self] mode -> Driver<Elements> in
                guard let self else { return .never() }
                
                switch mode {
                case .empty:
                    let elements = [CLItemsCollectionElement.selectItem(itemCategory)]
                    let setup = Elements.setup(elements)
                    return .just(setup)
                case .list(let initialItem):
                    var lastPageInfo: PageInfo?
                    
                    func fetch(page: Int, itemCategory: ItemCategory) -> Driver<Page<[Item]>> {
                        collectionsManager
                            .obtainItems(
                                category: ItemCategory.DefaultLocalized().name(category: itemCategory),
                                attachment: .internal,
                                page: page,
                                favorite: false
                            )
                            .asDriver(onErrorJustReturn: nil)
                            .compactMap { $0 }
                            .do(onNext: { page  in
                                lastPageInfo = page.info
                            })
                    }
                    
                    let firstPage = fetch(page: 1, itemCategory: itemCategory)
                    let downloadedPage = firstPage
                        .flatMapLatest { firstPage -> Driver<Page<[Item]>> in
                            didScrollToLast
                                .filter { $0 == itemCategory }
                                .asDriver(onErrorDriveWith: .never())
                                .compactMap { _ in lastPageInfo }
                                .filter { ($0.nextPage <= $0.total) && ($0.current != $0.total) }
                                .flatMapFirst { lastPageInfo -> Driver<Page<[Item]>> in
                                    fetch(page: lastPageInfo.nextPage, itemCategory: itemCategory)
                                }
                                .startWith(firstPage)
                        }
                    
                    return downloadedPage
                        .map { page -> Elements in
                            var pageItems = page.elements
                            
                            pageItems.removeAll(where: { $0.id == initialItem.id })
                            
                            var result = [CLItemsCollectionElement]()
                            
                            let isFirstPage = page.info.current == 1
                            
                            if isFirstPage {
                                let initialItemElement = CLItemsCollectionItemElement(
                                    item: initialItem,
                                    selected: true
                                )
                                let element = CLItemsCollectionElement.item(initialItemElement)
                                result.append(element)
                            }
                            
                            pageItems.forEach { item in
                                let itemElement = CLItemsCollectionItemElement(
                                    item: item,
                                    selected: false
                                )
                                let element = CLItemsCollectionElement.item(itemElement)
                                result.append(element)
                            }
                            
                            return isFirstPage ? .setup(result) : .append(result)
                        }
                }
            }
    }
}

// MARK: Additional
private extension CreateLookViewModel.ElementsMode {
    static func == (lhs: CreateLookViewModel.ElementsMode, rhs: CreateLookViewModel.ElementsMode) -> Bool {
        (lhs.isEmpty && rhs.isEmpty) || (lhs.isList && rhs.isList)
    }
    
    var isEmpty: Bool {
        switch self {
        case .empty:
            return true
        case .list:
            return false
        }
    }
    
    var isList: Bool {
        switch self {
        case .empty:
            return false
        case .list:
            return true
        }
    }
}
