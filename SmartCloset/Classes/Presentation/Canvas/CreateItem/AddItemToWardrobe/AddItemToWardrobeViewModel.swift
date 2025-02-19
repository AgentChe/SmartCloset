//
//  AddItemToWardrobeViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 13.02.2025.
//

import RxSwift
import RxCocoa

final class AddItemToWardrobeViewModel {
    enum Elements {
        case setup([AddItemToWardrobeCollectionElement])
        case append([AddItemToWardrobeCollectionElement])
    }
    
    enum Route {
        case close
        case selectItemType(ItemCategory, ItemType?)
        case paygate
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    private lazy var saveActivity = RxActivityIndicator()
    
    private lazy var collectionsManager = CollectionsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension AddItemToWardrobeViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didSelectCategory: Signal<ItemCategory>
        let didTapSelectType: Signal<Void>
        let didSelectItemType: Signal<ItemType>
        let didScrollToBottom: Signal<Void>
        let didTapSave: Signal<Void>
        let didChangeSelect: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
        let itemCategory: Driver<ItemCategory>
        let itemType: Driver<ItemType?>
        let firstPageActivity: Driver<Bool>
        let paginationActivity: Driver<Bool>
        let saveActivity: Driver<Bool>
        let elements: Driver<Elements>
        let canSave: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let itemCategory = makeItemCategory(didSelectCategory: input.didSelectCategory)
        let itemType = makeItemType(
            didSelectCategory: input.didSelectCategory,
            didSelectItemType: input.didSelectItemType
        )
        let elements = makeElements(
            itemCategory: itemCategory,
            itemType: itemType,
            didScrollToBottom: input.didScrollToBottom
        )
        let fullElements = makeFullElements(elements: elements)
        
        return Output(
            route: makeRoute(
                didTapClose: input.didTapClose,
                didTapSelectType: input.didTapSelectType,
                itemCategory: itemCategory,
                itemType: itemType,
                didTapSave: input.didTapSave,
                fullElements: fullElements
            ),
            itemCategory: itemCategory,
            itemType: itemType,
            firstPageActivity: firstPageActivity.asDriver(),
            paginationActivity: paginationActivity.asDriver(),
            saveActivity: saveActivity.asDriver(),
            elements: elements,
            canSave: makeCanSave(
                didChangeSelect: input.didChangeSelect,
                fullElements: fullElements
            )
        )
    }
}

// MARK: Private
private extension AddItemToWardrobeViewModel {
    struct FetchElementsResult {
        let elements: [AddItemToWardrobeCollectionElement]
        let isFirstPage: Bool
    }
    
    func makeCanSave(
        didChangeSelect: Signal<Void>,
        fullElements: Driver<[AddItemToWardrobeCollectionElement]>
    ) -> Driver<Bool> {
        didChangeSelect
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(fullElements)
            .map { $0.contains(where: { $0.marked }) }
            .startWith(false)
    }
    
    func makeFullElements(elements: Driver<Elements>) -> Driver<[AddItemToWardrobeCollectionElement]> {
        elements
            .scan([]) { all, fetch -> [AddItemToWardrobeCollectionElement] in
                switch fetch {
                case .setup(let elements):
                    return elements
                case .append(let elements):
                    return all + elements
                }
            }
    }
    
    func makeElements(
        itemCategory: Driver<ItemCategory>,
        itemType: Driver<ItemType?>,
        didScrollToBottom: Signal<Void>
    ) -> Driver<Elements> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int, itemCategory: ItemCategory, itemType: ItemType?) -> Driver<Page<[Item]>> {
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
            .flatMapLatest { category, type -> Driver<Page<[Item]>> in
                fetch(page: 1, itemCategory: category, itemType: type)
            }
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<[Item]>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .withLatestFrom(itemCategory)
                    .withLatestFrom(itemType) { ($0, $1) }
                    .compactMap { category, type -> (ItemCategory, ItemType?, PageInfo)? in
                        guard let lastPageInfo else { return nil }
                        return (category, type, lastPageInfo)
                    }
                    .filter { ($2.nextPage <= $2.total) && ($2.current != $2.total) }
                    .flatMapFirst { category, type, lastPageInfo -> Driver<Page<[Item]>> in
                        fetch(page: lastPageInfo.nextPage, itemCategory: category, itemType: type)
                    }
                    .startWith(firstPage)
            }
        
        return downloadedPage
            .map { page -> FetchElementsResult in
                let elements = page.elements.map { item -> AddItemToWardrobeCollectionElement in
                    AddItemToWardrobeCollectionElement(
                        item: item,
                        marked: false
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
    
    func makeRoute(
        didTapClose: Signal<Void>,
        didTapSelectType: Signal<Void>,
        itemCategory: Driver<ItemCategory>,
        itemType: Driver<ItemType?>,
        didTapSave: Signal<Void>,
        fullElements: Driver<[AddItemToWardrobeCollectionElement]>
    ) -> Driver<Route> {
        let close = didTapClose
            .map { Route.close }
            .asDriver(onErrorDriveWith: .never())
        
        let selectItemType = didTapSelectType
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(itemType)
            .withLatestFrom(itemCategory) { ($0, $1) }
            .map { Route.selectItemType($1, $0) }
        
        let saveOrPaygate = didTapSave
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(fullElements)
            .compactMap { $0.first(where: { $0.marked }) }
            .flatMapLatest { [weak self] element -> Driver<Route> in
                guard let self else { return .never() }
                
                guard SessionManager().hasActiveSubscriptions() else {
                    return .just(Route.paygate)
                }
                
                func source() -> Single<Void> {
                    collectionsManager
                        .addWardrobe(itemId: element.item.id)
                        .map { item -> Void in
                            guard item != nil else {
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
            .merge(close, selectItemType, saveOrPaygate)
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
}
