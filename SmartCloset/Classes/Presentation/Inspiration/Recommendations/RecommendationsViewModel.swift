//
//  RecommendationsViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 05.02.2025.
//

import RxSwift
import RxCocoa

final class RecommendationsViewModel {
    enum Elements {
        case setup([RecommendationsCollectionElement])
        case append([RecommendationsCollectionElement])
    }
    
    enum Route {
        case openItem(Item)
        case openLook(Look)
    }
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    
    private lazy var collectionsManager = CollectionsManager()
}

// MARK: Public
extension RecommendationsViewModel {
    struct Input {
        let didScrollToBottom: Signal<Void>
        let didSelectItem: Signal<Item>
        let didSelectLook: Signal<Look>
    }
    
    struct Output {
        let elements: Driver<Elements>
        let firstPageActivity: Driver<Bool>
        let paginationActivity: Driver<Bool>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            elements: makeElements(didScrollToBottom: input.didScrollToBottom),
            firstPageActivity: firstPageActivity.asDriver(),
            paginationActivity: paginationActivity.asDriver(),
            route: makeRoute(
                didSelectItem: input.didSelectItem,
                didSelectLook: input.didSelectLook
            )
        )
    }
}

// MARK: Private
private extension RecommendationsViewModel {
    func makeElements(didScrollToBottom: Signal<Void> ) -> Driver<Elements> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int) -> Driver<Page<Recommendations>> {
            collectionsManager
                .obtainRecommendations(page: page, limit: 20)
                .trackActivity(page == 1 ? firstPageActivity : paginationActivity)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 } 
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let firstPage = fetch(page: 1)
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<Recommendations>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .compactMap { lastPageInfo }
                    .filter { ($0.nextPage <= $0.total) && ($0.current != $0.total) }
                    .flatMapFirst { lastPageInfo -> Driver<Page<Recommendations>> in
                        fetch(page: lastPageInfo.nextPage)
                    }
                    .startWith(firstPage)
            }
        
        return downloadedPage
            .map { page -> Elements in
                let elements = RecommendationsCollectionElement.array(recommendations: page.elements) ?? []
                return page.info.current == 1 ? .setup(elements) : .append(elements)
            }
    }
    
    func makeRoute(
        didSelectItem: Signal<Item>,
        didSelectLook: Signal<Look>
    ) -> Driver<Route> {
        let openItem = didSelectItem
            .map { Route.openItem($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let openLook = didSelectLook
            .map { Route.openLook($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(openItem, openLook)
    }
}
