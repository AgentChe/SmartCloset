//
//  WardrobeCollectionsViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 16.02.2025.
//

import RxSwift
import RxCocoa

final class WardrobeCollectionsViewModel {
    enum Route {
        case openCollection(Collection)
        case createCollection
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
extension WardrobeCollectionsViewModel {
    struct Input {
        let didScrollToBottom: Signal<Void>
        let didSelectCollection: Signal<Collection>
        let didTapCreateCollection: Signal<Void>
    }
    
    struct Output {
        let elements: Driver<Elements>
        let firstPageActivity: Driver<Bool>
        let paginationActivity: Driver<Bool>
        let route: Driver<Route>
        let isEmpty: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let firstPageActivity = firstPageActivity.asDriver()
        let elements = makeElements(didScrollToBottom: input.didScrollToBottom)
        let fullElements = makeFullElements(elements: elements)
        
        return Output(
            elements: elements,
            firstPageActivity: firstPageActivity,
            paginationActivity: paginationActivity.asDriver(),
            route: makeRoute(
                didSelectCollection: input.didSelectCollection,
                didTapCreateCollection: input.didTapCreateCollection
            ),
            isEmpty: makeIsEmpty(
                fullElements: fullElements,
                firstPageActivity: firstPageActivity
            )
        )
    }
}

// MARK: Private
private extension WardrobeCollectionsViewModel {
    func makeElements(didScrollToBottom: Signal<Void>) -> Driver<Elements> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int) -> Driver<Page<[Collection]>> {
            collectionsManager
                .obtainCollections(attachment: .custom, terms: nil, page: page) // TODO: custom -> wardrobe
                .trackActivity(page == 1 ? firstPageActivity : paginationActivity)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let trigger = Signal<Void>
            .merge(
                CollectionsMediator.shared.collectionsDidChangeWardrobe,
                CollectionsMediator.shared.collectionCreated.map { _ in Void() },
                CollectionsMediator.shared.collectionDeleted.map { _ in Void() },
                CollectionsMediator.shared.collectionEdited.map { _ in Void() }
            )
            .startWith(())
        
        let firstPage = trigger
            .flatMapLatest { fetch(page: 1) }
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
    
    func makeRoute(
        didSelectCollection: Signal<Collection>,
        didTapCreateCollection: Signal<Void>
    ) -> Driver<Route> {
        let openCollection = didSelectCollection
            .map { Route.openCollection($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let createCollection = didTapCreateCollection
            .map { Route.createCollection }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(openCollection, createCollection)
    }
    
    func makeIsEmpty(
        fullElements: Driver<[Collection]>,
        firstPageActivity: Driver<Bool>
    ) -> Driver<Bool> {
        Driver
            .combineLatest(fullElements, firstPageActivity) { elements, firstPageActivity -> Bool in
                elements.isEmpty && !firstPageActivity
            }
            .startWith(false)
    }
    
    func makeFullElements(elements: Driver<Elements>) -> Driver<[Collection]> {
        elements
            .scan([]) { all, fetch -> [Collection] in
                switch fetch {
                case .setup(let elements):
                    return elements
                case .append(let elements):
                    return all + elements
                }
            }
    }
}
