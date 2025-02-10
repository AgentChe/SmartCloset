//
//  EditLookViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 08.02.2025.
//

import RxSwift
import RxCocoa

final class EditLookViewModel {
    enum Elements {
        case setup([CLItemsCollectionElement])
        case append([CLItemsCollectionElement])
    }
    
    enum Route {
        case close
        case selectItem(ItemCategory)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var activity = RxActivityIndicator()
    
    private let look: Driver<Look>
    
    private lazy var collectionsManager = CollectionsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(look: Look) {
        self.look = BehaviorRelay(value: look).asDriver()
    }
}

// MARK: Public
extension EditLookViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didTapSave: Signal<Void>
        let didSelectItem: Signal<(ItemCategory, Item?)>
        let didSelectItemCategory: Signal<ItemCategory>
        let didScrollToLast: Signal<ItemCategory>
    }
    
    struct Output {
        let route: Driver<Route>
        let canSaveLook: Driver<Bool>
        let topsElements: Driver<Elements>
        let bottomsElements: Driver<Elements>
        let shoesElements: Driver<Elements>
        let bagsElements: Driver<Elements>
        let accessoriesElements: Driver<Elements>
        let activity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let selectedTopItem = makeSelectedItem(
            look: look,
            didSelectItem: input.didSelectItem,
            equalItemCategory: .tops
        )
        let selectedBottomsItem = makeSelectedItem(
            look: look,
            didSelectItem: input.didSelectItem,
            equalItemCategory: .bottoms
        )
        let selectedShoesItem = makeSelectedItem(
            look: look,
            didSelectItem: input.didSelectItem,
            equalItemCategory: .shoes
        )
        let selectedBagsItem = makeSelectedItem(
            look: look,
            didSelectItem: input.didSelectItem,
            equalItemCategory: .bags
        )
        let selectedAccessoriesItem = makeSelectedItem(
            look: look,
            didSelectItem: input.didSelectItem,
            equalItemCategory: .accessories
        )
        let lookItems = makeLookItems(
            look: look,
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
                didTapSave: input.didTapSave,
                lookItems: lookItems
            ),
            canSaveLook: makeCanSaveLook(lookItems: lookItems),
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
            ),
            activity: activity.asDriver()
        )
    }
}

// MARK: Private
private extension EditLookViewModel {
    enum ElementsMode: Equatable {
        case empty
        case list(Item)
    }
    
    struct LookItems {
        let id: String
        let tops: Item?
        let bottoms: Item?
        let shoes: Item?
        let bags: Item?
        let accessories: Item?
    }
    
    func makeRoute(
        didTapClose: Signal<Void>,
        didSelectItemCategory: Signal<ItemCategory>,
        didTapSave: Signal<Void>,
        lookItems: Driver<LookItems>
    ) -> Driver<Route> {
        let close = didTapClose
            .map { Route.close }
            .asDriver(onErrorDriveWith: .never())
        
        let selectItem = didSelectItemCategory
            .map { Route.selectItem($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let save = didTapSave
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(lookItems)
            .flatMapLatest { [weak self] lookItems -> Driver<Route> in
                guard let self else { return .never() }
                
                func source() -> Single<Look> {
                    collectionsManager
                        .editLook(
                            id: lookItems.id,
                            topItemId: lookItems.tops?.id,
                            bottomItemId: lookItems.bottoms?.id,
                            shoesItemId: lookItems.shoes?.id,
                            bagsItemId: lookItems.bags?.id,
                            accessoriesItemId: lookItems.accessories?.id
                        )
                        .map { look -> Look in
                            guard let look else { throw ContentError(.notContent) }
                            return look
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    tryAgain?(error) ?? .empty()
                }
                
                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .trackActivity(activity)
                    .asDriver(onErrorDriveWith: .never())
                    .map { _ in Route.close }
            }
        
        return Driver
            .merge(close, selectItem, save)
    }
    
    func makeLookItems(
        look: Driver<Look>,
        selectedTopItem: Driver<Item?>,
        selectedBottomsItem: Driver<Item?>,
        selectedShoesItem: Driver<Item?>,
        selectedBagsItem: Driver<Item?>,
        selectedAccessoriesItem: Driver<Item?>
    ) -> Driver<LookItems> {
        Driver
            .combineLatest(
                look.map { $0.id },
                selectedTopItem,
                selectedBottomsItem,
                selectedShoesItem,
                selectedBagsItem,
                selectedAccessoriesItem
            ) { id, tops, bottoms, shoes, bags, accessories -> LookItems in
                LookItems(
                    id: id,
                    tops: tops,
                    bottoms: bottoms,
                    shoes: shoes,
                    bags: bags,
                    accessories: accessories
                )
            }
    }
    
    func makeSelectedItem(
        look: Driver<Look>,
        didSelectItem: Signal<(ItemCategory, Item?)>,
        equalItemCategory: ItemCategory
    ) -> Driver<Item?> {
        Driver
            .merge(
                didSelectItem
                    .asDriver(onErrorDriveWith: .never())
                    .filter { $0.0 == equalItemCategory }
                    .compactMap { $1 },
                look.compactMap { $0.item(for: equalItemCategory) }
            )
            .startWith(nil)
    }
    
    func makeCanSaveLook(lookItems: Driver<LookItems>) -> Driver<Bool> {
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
private extension EditLookViewModel.ElementsMode {
    static func == (lhs: EditLookViewModel.ElementsMode, rhs: EditLookViewModel.ElementsMode) -> Bool {
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

// MARK: Private
private extension Look {
    func item(for category: ItemCategory) -> Item? {
        switch category {
        case .tops:
            return top
        case .bottoms:
            return bottom
        case .shoes:
            return shoes
        case .bags:
            return bags
        case .accessories:
            return accessories
        }
    }
}
