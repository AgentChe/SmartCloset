//
//  CollectionsViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 17.02.2025.
//

import RxSwift
import RxCocoa

final class CollectionsViewModel {
    enum Route {
        case openCollection(Collection)
    }
    
    enum Elements {
        case setup([Collection])
        case append([Collection])
    }
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    
    private lazy var collectionsManager = CollectionsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension CollectionsViewModel {
    struct Input {
        let didScrollToBottom: Signal<Void>
        let didSelectCollection: Signal<Collection>
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
            route: makeRoute(didSelectCollection: input.didSelectCollection)
        )
    }
}

// MARK: Private
private extension CollectionsViewModel {
    func makeElements(didScrollToBottom: Signal<Void>) -> Driver<Elements> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int) -> Driver<Page<[Collection]>> {
            collectionsManager
                .obtainCollections(attachment: .internal, terms: nil, page: page) 
                .trackActivity(page == 1 ? firstPageActivity : paginationActivity)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let firstPage = fetch(page: 1)
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<[Collection]>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .compactMap { lastPageInfo }
                    .filter { ($0.nextPage <= $0.total) && ($0.current != $0.total) }
                    .flatMapFirst { lastPageInfo -> Driver<Page<[Collection]>> in
                        fetch(page: lastPageInfo.nextPage)
                    }
                    .startWith(firstPage)
            }
        
        return downloadedPage
            .map { page -> Elements in
                page.info.current == 1 ? Elements.setup(page.elements) : Elements.append(page.elements)
            }
    }
    
    func makeRoute(didSelectCollection: Signal<Collection>) -> Driver<Route> {
        let openCollection = didSelectCollection
            .map { Route.openCollection($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(openCollection)
    }
}
