//
//  CCSelectLooksViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 09.02.2025.
//

import RxSwift
import RxCocoa

final class CCSelectLooksViewModel {
    enum FetchElements {
        case setup([CCSLLooksCollectionElement])
        case append([CCSLLooksCollectionElement])
    }
    
    enum Route {
        case close
        case result([Look])
        case createLook
    }
    
    private let selectedLooksIds: Driver<[String]>
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    
    private lazy var collectionsManager = CollectionsManager()
    
    init(selectedLooksIds: [String]) {
        self.selectedLooksIds = BehaviorRelay(value: selectedLooksIds).asDriver()
    }
}

// MARK: Public
extension CCSelectLooksViewModel {
    struct Input {
        let didSelectAttachment: Signal<CCSLAttachmentItemButton.Attachment>
        let didTapClose: Signal<Void>
        let didTapChangeFavoriteFilter: Signal<Void>
        let didScrollToBottom: Signal<Void>
        let didSelectElement: Signal<Void>
        let didTapConfirmSelectedLooks: Signal<Void>
        let didTapCreateLook: Signal<Void>
        let didForceUpdate: Signal<Void>
    }
    
    struct Output {
        let attachment: Driver<CCSLAttachmentItemButton.Attachment>
        let route: Driver<Route>
        let onlyFavorite: Driver<Bool>
        let elements: Driver<FetchElements>
        let firstPageActivity: Driver<Bool>
        let paginationActivity: Driver<Bool>
        let countSelectedElements: Driver<Int>
        let isEmpty: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let attachment = makeAttachment(didSelectAttachment: input.didSelectAttachment)
        let onlyFavorite = makeOnlyFavorite(didTapChangeFavoriteFilter: input.didTapChangeFavoriteFilter)
        let searchData = makeSearchData(
            attachment: attachment,
            onlyFavorite: onlyFavorite
        )
        let elements = makeElements(
            searchData: searchData,
            didScrollToBottom: input.didScrollToBottom,
            didForceUpdate: input.didForceUpdate
        )
        let fullElements = makeFullElements(elements: elements)
        let firstPageActivity = firstPageActivity.asDriver()
        
        return Output(
            attachment: attachment,
            route: makeRoute(
                didTapClose: input.didTapClose,
                didTapConfirmSelectedLooks: input.didTapConfirmSelectedLooks,
                fullElements: fullElements,
                didTapCreateLook: input.didTapCreateLook
            ),
            onlyFavorite: onlyFavorite,
            elements: elements,
            firstPageActivity: firstPageActivity,
            paginationActivity: paginationActivity.asDriver(),
            countSelectedElements: makeCountSelectedElements(
                didSelectElement: input.didSelectElement,
                fullElements: fullElements
            ),
            isEmpty: makeIsEmpty(
                fullElements: fullElements,
                firstPageActivity: firstPageActivity
            )
        )
    }
}

// MARK: Private
private extension CCSelectLooksViewModel {
    struct SearchData {
        let attachment: CCSLAttachmentItemButton.Attachment
        let onlyFavorite: Bool
    }
    
    func makeIsEmpty(
        fullElements: Driver<[CCSLLooksCollectionElement]>,
        firstPageActivity: Driver<Bool>
    ) -> Driver<Bool> {
        Driver
            .combineLatest(fullElements, firstPageActivity) { elements, firstPageActivity -> Bool in
                elements.isEmpty && !firstPageActivity
            }
            .startWith(false)
    }
    
    func makeCountSelectedElements(
        didSelectElement: Signal<Void>,
        fullElements: Driver<[CCSLLooksCollectionElement]>
    ) -> Driver<Int> {
        Driver
            .merge(
                didSelectElement
                    .asDriver(onErrorDriveWith: .never())
                    .withLatestFrom(fullElements),
                fullElements
            )
            .map { $0.count(where: { $0.marked }) }
            .startWith(0)
    }
    
    func makeSearchData(
        attachment: Driver<CCSLAttachmentItemButton.Attachment>,
        onlyFavorite: Driver<Bool>
    ) -> Driver<SearchData> {
        Driver
            .combineLatest(attachment, onlyFavorite) { attachment, onlyFavorite -> SearchData in
                SearchData(attachment: attachment, onlyFavorite: onlyFavorite)
            }
    }
    
    func makeAttachment(didSelectAttachment: Signal<CCSLAttachmentItemButton.Attachment>) -> Driver<CCSLAttachmentItemButton.Attachment> {
        didSelectAttachment
            .asDriver(onErrorDriveWith: .never())
            .startWith(.internal)
    }
    
    func makeOnlyFavorite(didTapChangeFavoriteFilter: Signal<Void>) -> Driver<Bool> {
        didTapChangeFavoriteFilter
            .scan(false) { onlyFavorite, _ -> Bool in
                !onlyFavorite}
            .asDriver(onErrorDriveWith: .never())
            .startWith(false)
    }
    
    func makeRoute(
        didTapClose: Signal<Void>,
        didTapConfirmSelectedLooks: Signal<Void>,
        fullElements: Driver<[CCSLLooksCollectionElement]>,
        didTapCreateLook: Signal<Void>
    ) -> Driver<Route> {
        let close = didTapClose
            .map { Route.close }
            .asDriver(onErrorDriveWith: .never())
        
        let result = didTapConfirmSelectedLooks
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(fullElements)
            .map { elements -> Route in
                let looks = elements
                    .filter { $0.marked }
                    .map { $0.look }
                return .result(looks)
            }
        
        let createLook = didTapCreateLook
            .map { Route.createLook }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(close, result, createLook)
    }
    
    func makeElements(
        searchData: Driver<SearchData>,
        didScrollToBottom: Signal<Void>,
        didForceUpdate: Signal<Void>
    ) -> Driver<FetchElements> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int, data: SearchData) -> Driver<Page<[Look]>> {
            collectionsManager
                .obtainLooks(
                    attachment: {
                        switch data.attachment {
                        case .custom:
                            return .custom
                        case .internal:
                            return .internal
                        }
                    }(),
                    terms: nil,
                    page: page,
                    favorite: data.onlyFavorite ? data.onlyFavorite: nil
                )
                .trackActivity(page == 1 ? firstPageActivity : paginationActivity)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let initialTrigger = Driver
            .merge(
                searchData,
                didForceUpdate
                    .asDriver(onErrorDriveWith: .never())
                    .withLatestFrom(searchData)
            )
        
        let firstPage = initialTrigger
            .flatMapLatest { data -> Driver<Page<[Look]>> in
                fetch(page: 1, data: data)
            }
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<[Look]>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .withLatestFrom(searchData)
                    .compactMap { data -> (SearchData, PageInfo)? in
                        guard let lastPageInfo else { return nil }
                        return (data, lastPageInfo)
                    }
                    .filter { ($1.nextPage <= $1.total) && ($1.current != $1.total) }
                    .flatMapFirst { data, lastPageInfo -> Driver<Page<[Look]>> in
                        fetch(page: lastPageInfo.nextPage, data: data)
                    }
                    .startWith(firstPage)
            }
        
        let downloadedElements = downloadedPage
            .map { page -> FetchElements in
                let elements = page.elements.map { look -> CCSLLooksCollectionElement in
                    CCSLLooksCollectionElement(
                        look: look,
                        marked: false
                    )
                }
                
                return page.info.current == 1 ? .setup(elements) : .append(elements)
            }
        
        let reset = searchData
            .map { _ in FetchElements.setup([]) }
        
        return Driver
            .merge(downloadedElements, reset)
    }
    
    func makeFullElements(elements: Driver<FetchElements>) -> Driver<[CCSLLooksCollectionElement]> {
        elements
            .scan([]) { all, fetch -> [CCSLLooksCollectionElement] in
                switch fetch {
                case .setup(let elements):
                    return elements
                case .append(let elements):
                    return all + elements
                }
            }
    }
}
