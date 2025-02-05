//
//  ItemCategoryViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 04.02.2025.
//

import RxSwift
import RxCocoa

final class ItemCategoryViewModel {
    enum Elements {
        case setup([SICollectionElement])
        case append([SICollectionElement])
    }
    
    enum Action {
        case changeFavorite(String, Bool)
    }
    
    enum Route {
        case selectItemType(ItemCategory, ItemType?)
        case openItem(Item)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private let itemCategory: Driver<ItemCategory>
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    
    private lazy var collectionsManager = CollectionsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(itemCategory: ItemCategory) {
        self.itemCategory = BehaviorRelay(value: itemCategory).asDriver()
    }
}

// MARK: Public
extension ItemCategoryViewModel {
    struct Input {
        let didTapSelectType: Signal<Void>
        let didSelectItemType: Signal<ItemType>
        let didScrollToBottom: Signal<Void>
        let didTapFavorite: Signal<SICollectionElement>
        let didSelectItem: Signal<Item>
    }
    
    struct Output {
        let route: Driver<Route>
        let itemType: Driver<ItemType?>
        let elements: Driver<Elements>
        let firstPageActivity: Driver<Bool>
        let paginationActivity: Driver<Bool>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        let itemType = makeItemType(didSelectItemType: input.didSelectItemType)
        
        return Output(
            route: makeRoute(
                didTapSelectType: input.didTapSelectType,
                itemType: itemType,
                itemCategory: itemCategory,
                didSelectItem: input.didSelectItem
            ),
            itemType: itemType,
            elements: makeElements(
                itemCategory: itemCategory,
                itemType: itemType,
                didScrollToBottom: input.didScrollToBottom
            ),
            firstPageActivity: firstPageActivity.asDriver(),
            paginationActivity: paginationActivity.asDriver(),
            action: makeAction(didTapFavorite: input.didTapFavorite)
        )
    }
}

// MARK: Private
private extension ItemCategoryViewModel {
    struct FetchElementsResult {
        let elements: [SICollectionElement]
        let isFirstPage: Bool
    }
    
    func makeItemType(didSelectItemType: Signal<ItemType>) -> Driver<ItemType?> {
        didSelectItemType
            .map { itemType -> ItemType? in itemType }
            .startWith(nil)
            .asDriver(onErrorJustReturn: nil)
    }
    
    func makeRoute(
        didTapSelectType: Signal<Void>,
        itemType: Driver<ItemType?>,
        itemCategory: Driver<ItemCategory>,
        didSelectItem: Signal<Item>
    ) -> Driver<Route> {
        let selectItemType = didTapSelectType
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(itemType)
            .withLatestFrom(itemCategory) { ($0, $1) }
            .map { Route.selectItemType($1, $0) }
        
        let openItem = didSelectItem
            .map { Route.openItem($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(selectItemType, openItem)
    }
    
    func makeElements(
        itemCategory: Driver<ItemCategory>,
        itemType: Driver<ItemType?>,
        didScrollToBottom: Signal<Void>
    ) -> Driver<Elements> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int, itemCategory: ItemCategory, itemType: ItemType?) -> Driver<Page<Item>> {
            let terms = [itemType].compactMap { $0 }
            
            return collectionsManager
                .obtainItems(
                    category: ItemCategory.DefaultLocalized().name(category: itemCategory),
                    attachment: .internal,
                    terms: terms,
                    page: page
                )
                .trackActivity(page == 1 ? firstPageActivity : paginationActivity)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let firstPage = itemType
            .withLatestFrom(itemCategory) { ($1, $0) }
            .flatMapLatest { category, type -> Driver<Page<Item>> in
                fetch(page: 1, itemCategory: category, itemType: type)
            }
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<Item>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .withLatestFrom(itemCategory)
                    .withLatestFrom(itemType) { ($0, $1) }
                    .compactMap { category, type -> (ItemCategory, ItemType?, PageInfo)? in
                        guard let lastPageInfo else { return nil }
                        return (category, type, lastPageInfo)
                    }
                    .filter { ($2.nextPage <= $2.total) && ($2.current != $2.total) }
                    .flatMapFirst { category, type, lastPageInfo -> Driver<Page<Item>> in
                        fetch(page: lastPageInfo.nextPage, itemCategory: category, itemType: type)
                    }
                    .startWith(firstPage)
            }
        
        return downloadedPage
            .map { page -> FetchElementsResult in
                let elements = page.elements.map { item -> SICollectionElement in
                    SICollectionElement(
                        item: item,
                        favorite: item.isFavorite
                    )
                }
                return FetchElementsResult(
                    elements: elements,
                    isFirstPage: page.info.current == 1
                )
            }
            .map { result -> Elements in
                result.isFirstPage ? .setup(result.elements) : .append(result.elements)
            }
    }
    
    func makeAction(didTapFavorite: Signal<SICollectionElement>) -> Driver<Action> {
        let changeFavorite = didTapFavorite
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
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(changeFavorite)
    }
}
