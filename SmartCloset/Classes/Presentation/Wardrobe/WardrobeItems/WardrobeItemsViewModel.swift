//
//  WardrobeItemsViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 16.02.2025.
//

import RxSwift
import RxCocoa

final class WardrobeItemsViewModel {
    enum Elements {
        case setup([WICollectionElement])
        case append([WICollectionElement])
    }
    
    enum Route {
        case selectItemType(ItemCategory, ItemType?)
        case openItem(Item)
        case createItem
        case paygate
    }
    
    enum Action {
        case changeFavorite(String, Bool)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    
    private lazy var collectionsManager = CollectionsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension WardrobeItemsViewModel {
    struct Input {
        let didSelectCategory: Signal<ItemCategory>
        let didTapSelectType: Signal<Void>
        let didSelectItemType: Signal<ItemType>
        let didTapFavoriteMode: Signal<Void>
        let didChangeFavoriteElement: Signal<WICollectionElement>
        let didScrollToBottom: Signal<Void>
        let didTapFavorite: Signal<WICollectionElement>
        let didTapItem: Signal<Item>
        let didTapCreateItem: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
        let itemCategory: Driver<ItemCategory>
        let itemType: Driver<ItemType?>
        let firstPageActivity: Driver<Bool>
        let paginationActivity: Driver<Bool>
        let isFavoriteMode: Driver<Bool>
        let elements: Driver<Elements>
        let action: Driver<Action>
        let isEmpty: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let itemCategory = makeItemCategory(didSelectCategory: input.didSelectCategory)
        let itemType = makeItemType(
            didSelectCategory: input.didSelectCategory,
            didSelectItemType: input.didSelectItemType
        )
        let isFavoriteMode = makeIsFavorite(didTapFavorite: input.didTapFavoriteMode)
        let searchData = makeSearchData(
            itemCategory: itemCategory,
            itemType: itemType,
            favoriteMode: isFavoriteMode
        )
        let elements = makeElements(
            searchData: searchData,
            didScrollToBottom: input.didScrollToBottom
        )
        let fullElements = makeFullElements(elements: elements)
        let firstPageActivity = firstPageActivity.asDriver()
        
        return Output(
            route: makeRoute(
                didTapSelectType: input.didTapSelectType,
                itemCategory: itemCategory,
                itemType: itemType,
                didTapItem: input.didTapItem,
                didTapCreateItem: input.didTapCreateItem,
                didTapFavorite: input.didTapFavorite
            ),
            itemCategory: itemCategory,
            itemType: itemType,
            firstPageActivity: firstPageActivity,
            paginationActivity: paginationActivity.asDriver(),
            isFavoriteMode: isFavoriteMode,
            elements: elements,
            action: makeFavoriteAction(didTapFavorite: input.didTapFavorite),
            isEmpty: makeIsEmpty(
                fullElements: fullElements,
                firstPageActivity: firstPageActivity
            )
        )
    }
}

// MARK: Private
private extension WardrobeItemsViewModel {
    struct SearchData {
        let itemCategory: ItemCategory
        let itemType: ItemType?
        let favoriteMode: Bool
    }
    
    func makeElements(
        searchData: Driver<SearchData>,
        didScrollToBottom: Signal<Void>
    ) -> Driver<Elements> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int, searchData: SearchData) -> Driver<Page<[Item]>> {
            let terms = [searchData.itemType].compactMap { $0 }
            
            return collectionsManager
                .obtainItems(
                    category: ItemCategory.DefaultLocalized().name(category: searchData.itemCategory),
                    attachment: .wardrobe,
                    terms: terms,
                    page: page,
                    favorite: searchData.favoriteMode ? true : nil
                )
                .trackActivity(page == 1 ? firstPageActivity : paginationActivity)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let updateTriggers = Signal<Void>
            .merge(
                CollectionsMediator.shared.itemEdited.map { _ in Void() },
                CollectionsMediator.shared.itemCreated.map { _ in Void() },
                CollectionsMediator.shared.itemDeleted.map { _ in Void() },
                CollectionsMediator.shared.itemsDidChangeWardrobe.map { _ in Void() }
            )
            .startWith(())
            .withLatestFrom(searchData)
            .asDriver(onErrorDriveWith: .never())
        
        let trigger = Driver<SearchData>
            .merge(updateTriggers, searchData)
        
        let firstPage = trigger
            .withLatestFrom(searchData)
            .flatMapLatest { searchData -> Driver<Page<[Item]>> in
                fetch(page: 1, searchData: searchData)
            }
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<[Item]>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .withLatestFrom(searchData)
                    .compactMap {searchData -> (SearchData, PageInfo)? in
                        guard let lastPageInfo else { return nil }
                        return (searchData, lastPageInfo)
                    }
                    .filter { ($1.nextPage <= $1.total) && ($1.current != $1.total) }
                    .flatMapFirst { searchData, lastPageInfo -> Driver<Page<[Item]>> in
                        fetch(page: lastPageInfo.nextPage, searchData: searchData)
                    }
                    .startWith(firstPage)
            }
        
        return downloadedPage
            .map { page -> Elements in
                let elements = page.elements.map { item -> WICollectionElement in
                    WICollectionElement(
                        item: item,
                        favorite: item.isFavorite
                    )
                }
                
                let isFirstPage = page.info.current == 1
                
                return isFirstPage ? .setup(elements) : .append(elements)
            }
    }
    
    func makeRoute(
        didTapSelectType: Signal<Void>,
        itemCategory: Driver<ItemCategory>,
        itemType: Driver<ItemType?>,
        didTapItem: Signal<Item>,
        didTapCreateItem: Signal<Void>,
        didTapFavorite: Signal<WICollectionElement>
    ) -> Driver<Route> {
        let selectItemType = didTapSelectType
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(itemType)
            .withLatestFrom(itemCategory) { ($0, $1) }
            .map { Route.selectItemType($1, $0) }
        
        let openItem = didTapItem
            .map { Route.openItem($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let createItem = didTapCreateItem
            .map { Route.createItem }
            .asDriver(onErrorDriveWith: .never())
        
        let paygate = didTapFavorite
            .filter { _ in !SessionManager().hasActiveSubscriptions() }
            .map { _ in Route.paygate }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(selectItemType, openItem, createItem, paygate)
    }
    
    func makeItemCategory(didSelectCategory: Signal<ItemCategory>) -> Driver<ItemCategory> {
        didSelectCategory
            .asDriver(onErrorDriveWith: .never())
            .startWith(.tops)
    }
    
    func makeItemType(
        didSelectCategory: Signal<ItemCategory>,
        didSelectItemType: Signal<ItemType>
    ) -> Driver<ItemType?> {
        let reset = didSelectCategory
            .map { _ -> ItemType? in nil }
            .asDriver(onErrorDriveWith: .never())
        
        let select = didSelectItemType
            .map { itemType -> ItemType? in itemType }
            .asDriver(onErrorDriveWith: .never())
            .startWith(nil)
        
        return Driver
            .merge(reset, select)
    }
    
    func makeIsFavorite(didTapFavorite: Signal<Void>) -> Driver<Bool> {
        didTapFavorite
            .asDriver(onErrorDriveWith: .never())
            .scan(false) { current, void -> Bool in
                !current
            }
            .startWith(false)
    }
    
    func makeSearchData(
        itemCategory: Driver<ItemCategory>,
        itemType: Driver<ItemType?>,
        favoriteMode: Driver<Bool>
    ) -> Driver<SearchData> {
        Driver
            .combineLatest(itemCategory, itemType, favoriteMode)
            .map { itemCategory, itemType, favoriteMode -> SearchData in
                SearchData(
                    itemCategory: itemCategory,
                    itemType: itemType,
                    favoriteMode: favoriteMode
                )
            }
    }
    
    func makeFavoriteAction(didTapFavorite: Signal<WICollectionElement>) -> Driver<Action> {
        let tap = didTapFavorite
            .filter { _ in SessionManager().hasActiveSubscriptions() }
            .flatMapLatest { [weak self] element -> Driver<Action> in
                guard let self else { return .never() }
                
                func source() -> Single<Action> {
                    let id = element.item.id
                    
                    let single = element.favorite
                        ? collectionsManager.removeFavorite(id: id, tab: .items)
                        : collectionsManager.addFavorite(id: id, tab: .items)
                    
                    return single
                        .flatMap { result -> Single<Action> in
                            guard result.success else { return .error(NetworkError(.serverNotAvailable)) }
                            
                            let action = Action.changeFavorite(id, !element.favorite)
                            return .just(action)
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
                    .flatMap { _ -> Driver<Action> in .never() }
                    .asDriver(onErrorDriveWith: .never())
            }
        
        let update = Signal<Action>
            .merge(
                CollectionsMediator.shared
                    .itemAddFavorite
                    .map { Action.changeFavorite($0, true) },
                CollectionsMediator.shared
                    .itemRemoveFromFavorite
                    .map { Action.changeFavorite($0, false) }
            )
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(tap, update)
    }
    
    func makeIsEmpty(
        fullElements: Driver<[WICollectionElement]>,
        firstPageActivity: Driver<Bool>
    ) -> Driver<Bool> {
        Driver
            .combineLatest(fullElements, firstPageActivity) { elements, firstPageActivity -> Bool in
                elements.isEmpty && !firstPageActivity
            }
            .startWith(false)
    }
    
    func makeFullElements(elements: Driver<Elements>) -> Driver<[WICollectionElement]> {
        elements
            .scan([]) { all, fetch -> [WICollectionElement] in
                switch fetch {
                case .setup(let elements):
                    return elements
                case .append(let elements):
                    return all + elements
                }
            }
    }
}
