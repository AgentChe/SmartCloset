//
//  SearchItemsViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 01.02.2025.
//

import RxSwift
import RxCocoa

final class SearchItemsViewModel {
    enum Action {
        case setup([SICollectionElement])
        case append([SICollectionElement])
        case route(Route)
        case changeFavorite(String, Bool)
    }
    
    enum Route {
        case openFilter(SIFilterViewController.Data)
        case openItem(Item)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    
    private lazy var collectionsManager = CollectionsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension SearchItemsViewModel {
    struct Input {
        let didTapFilter: Signal<Void>
        let appliedFilter: Signal<SIFilterViewController.Data>
        let search: Signal<String>
        let didScrollToBottom: Signal<Void>
        let didTapFavorite: Signal<SICollectionElement>
        let didSelectItem: Signal<Item>
    }
    
    struct Output {
        let selectedFilterItemsCount: Driver<Int>
        let action: Driver<Action>
        let emptyMode: Driver<SearchItemsEmptyView.Mode>
        let emptyHidden: Driver<Bool>
        let firstPageActivity: Driver<Bool>
        let paginationActivity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let filter = makeFilter(appliedFilter: input.appliedFilter)
        let initialSearch = makeInitialSearch(
            filter: filter,
            search: input.search
        )
        let elements = makeElements(
            initialSearch: initialSearch,
            didScrollToBottom: input.didScrollToBottom
        )
        
        return Output(
            selectedFilterItemsCount: makeSelectedFilterItemsCount(filter: filter),
            action: makeAction(
                elements: elements,
                didTapFilter: input.didTapFilter,
                filter: filter,
                didTapFavorite: input.didTapFavorite,
                didSelectItem: input.didSelectItem
            ),
            emptyMode: makeEmptyMode(initialSearch: initialSearch),
            emptyHidden: makeEmptyHidden(
                initialSearch: initialSearch,
                elements: elements
            ),
            firstPageActivity: firstPageActivity.asDriver(),
            paginationActivity: paginationActivity.asDriver()
        )
    }
}

// MARK: Private
private extension SearchItemsViewModel {
    struct FetchElementsResult {
        let elements: [SICollectionElement]
        let isFirstPage: Bool
    }
    
    struct InitialSearchData {
        let string: String?
        let filter: SIFilterViewController.Data?
    }
    
    func makeSelectedFilterItemsCount(filter: Driver<SIFilterViewController.Data>) -> Driver<Int> {
        filter
            .map { data -> Int in
                var count = 0
                if data.category != nil { count += 1 }
                if data.type != nil { count += 1 }
                if data.color != nil { count += 1 }
                if data.material != nil { count += 1 }
                return count
            }
    }
    
    func makeFilter(appliedFilter: Signal<SIFilterViewController.Data>) -> Driver<SIFilterViewController.Data> {
        appliedFilter
            .asDriver(onErrorDriveWith: .never())
            .startWith(SIFilterViewController.Data(
                category: nil,
                type: nil,
                color: nil,
                material: nil)
            )
    }
    
    func makeInitialSearch(
        filter: Driver<SIFilterViewController.Data>,
        search: Signal<String>
    ) -> Driver<InitialSearchData> {
        Driver
            .combineLatest(search.asDriver(onErrorDriveWith: .never()), filter)
            .map { string, filter -> InitialSearchData in
                InitialSearchData(
                    string: string,
                    filter: filter
                )
            }
    }
    
    func makeElements(
        initialSearch: Driver<InitialSearchData>,
        didScrollToBottom: Signal<Void>
    ) -> Driver<FetchElementsResult> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int, data: InitialSearchData) -> Driver<Page<Item>> {
            let category: String? = {
                guard let category = data.filter?.category else { return nil }
                return ItemCategory.DefaultLocalized().name(category: category)
            }()
            
            let terms: [String]? = {
                var result = [String]()
                
                if let type = data.filter?.type {
                    result.append(type)
                }
                
                if let color = data.filter?.color?.name {
                    result.append(color)
                }
                
                if let name = data.filter?.material?.name {
                    result.append(name)
                }
                
                return result.isEmpty ? nil : result
            }()
            
            return collectionsManager
                .obtainItems(
                    category: category,
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
        
        let firstPage = initialSearch
            .flatMapLatest { data -> Driver<Page<Item>> in
                fetch(page: 1, data: data)
            }
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<Item>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .withLatestFrom(initialSearch)
                    .compactMap { data -> (InitialSearchData, PageInfo)? in
                        guard let lastPageInfo else { return nil }
                        return (data, lastPageInfo)
                    }
                    .filter { ($1.nextPage <= $1.total) && ($1.current != $1.total) }
                    .flatMapFirst { data, lastPageInfo -> Driver<Page<Item>> in
                        fetch(page: lastPageInfo.nextPage, data: data)
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
    }
    
    func makeEmptyMode(initialSearch: Driver<InitialSearchData>) -> Driver<SearchItemsEmptyView.Mode> {
        initialSearch
            .map { _ in SearchItemsEmptyView.Mode.empty }
            .startWith(.whatLooking)
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeEmptyHidden(
        initialSearch: Driver<InitialSearchData>,
        elements: Driver<FetchElementsResult>
    ) -> Driver<Bool> {
        let hiddenWhenStartSearch = initialSearch
            .map { _ in true }
        
        let hiddenIfHasElements = elements
            .filter { $0.isFirstPage }
            .map { !$0.elements.isEmpty }
        
        return Driver
            .merge(hiddenWhenStartSearch, hiddenIfHasElements)
    }
    
    func makeAction(
        elements: Driver<FetchElementsResult>,
        didTapFilter: Signal<Void>,
        filter: Driver<SIFilterViewController.Data>,
        didTapFavorite: Signal<SICollectionElement>,
        didSelectItem: Signal<Item>
    ) -> Driver<Action> {
        let setupOrAppend = elements
            .map { result -> Action in
                result.isFirstPage ? .setup(result.elements) : .append(result.elements)
            }
        
        let route = makeRoute(
            didTapFilter: didTapFilter,
            filter: filter,
            didSelectItem: didSelectItem
        ).map { Action.route($0) }
        
        let favorite = makeFavorite(didTapFavorite: didTapFavorite)
        
        return Driver
            .merge(setupOrAppend, route, favorite)
    }
    
    func makeRoute(
        didTapFilter: Signal<Void>,
        filter: Driver<SIFilterViewController.Data>,
        didSelectItem: Signal<Item>
    ) -> Driver<Route> {
        let openFilter = didTapFilter
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(filter)
            .map { Route.openFilter($0) }
        
        let openItem = didSelectItem
            .map { Route.openItem($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(openFilter, openItem)
    }
    
    func makeFavorite(didTapFavorite: Signal<SICollectionElement>) -> Driver<Action> {
        didTapFavorite
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
    }
}
