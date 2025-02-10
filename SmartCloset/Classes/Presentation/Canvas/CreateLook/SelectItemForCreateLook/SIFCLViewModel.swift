//
//  SIFCLViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 06.02.2025.
//

import RxSwift
import RxCocoa

final class SIFCLViewModel {
    enum FetchElements {
        case setup([SIFCLCollectionElement])
        case append([SIFCLCollectionElement])
    }
    
    enum Route {
        case close
        case result(SIFCLViewController.Result)
    }
    
    private let itemCategory: Driver<ItemCategory>
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    
    private lazy var collectionsManager = CollectionsManager()
    
    init(itemCategory: ItemCategory) {
        self.itemCategory = BehaviorRelay(value: itemCategory).asDriver()
    }
}

// MARK: Public
extension SIFCLViewModel {
    struct Input {
        let didSelectAttachment: Signal<SIFCLAttachmentItemButton.Attachment>
        let didTapClose: Signal<Void>
        let didInputTextFilter: Signal<String>
        let didScrollToBottom: Signal<Void>
        let didTapContinue: Signal<Void>
    }
    
    struct Output {
        let attachment: Driver<SIFCLAttachmentItemButton.Attachment>
        let route: Driver<Route>
        let elements: Driver<FetchElements>
        let firstPageActivity: Driver<Bool>
        let paginationActivity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let attachment = makeAttachment(didSelectAttachment: input.didSelectAttachment)
        let textFilter = makeTextFilter(didInputTextFilter: input.didInputTextFilter)
        let searchData = makeSearchData(
            attachment: attachment,
            textFilter: textFilter,
            itemCategory: itemCategory
        )
        let elements = makeElements(
            searchData: searchData,
            didScrollToBottom: input.didScrollToBottom
        )
        let fullElements = makeFullElements(elements: elements)
        
        return Output(
            attachment: attachment,
            route: makeRoute(
                didTapClose: input.didTapClose,
                didTapContinue: input.didTapContinue,
                fullElements: fullElements,
                itemCategory: itemCategory
            ),
            elements: elements,
            firstPageActivity: firstPageActivity.asDriver(),
            paginationActivity: paginationActivity.asDriver()
        )
    }
}

// MARK: Private
private extension SIFCLViewModel {
    struct SearchData {
        let attachment: SIFCLAttachmentItemButton.Attachment
        let textFilter: String?
        let itemCategory: ItemCategory
    }
    
    func makeSearchData(
        attachment: Driver<SIFCLAttachmentItemButton.Attachment>,
        textFilter: Driver<String?>,
        itemCategory: Driver<ItemCategory>
    ) -> Driver<SearchData> {
        Driver
            .combineLatest(attachment, textFilter, itemCategory) { attachment, textFilter, itemCategory -> SearchData in
                SearchData(
                    attachment: attachment,
                    textFilter: textFilter,
                    itemCategory: itemCategory
                )
            }
    }
    
    func makeTextFilter(didInputTextFilter: Signal<String>) -> Driver<String?> {
        didInputTextFilter
            .map { text -> String? in
                let trimming = text.trimmingCharacters(in: .whitespacesAndNewlines)
                return trimming.isEmpty ? nil : trimming
            }
            .startWith(nil)
            .asDriver(onErrorJustReturn: nil)
    }
    
    func makeAttachment(didSelectAttachment: Signal<SIFCLAttachmentItemButton.Attachment>) -> Driver<SIFCLAttachmentItemButton.Attachment> {
        didSelectAttachment
            .asDriver(onErrorDriveWith: .never())
            .startWith(.internal)
    }
    
    func makeRoute(
        didTapClose: Signal<Void>,
        didTapContinue: Signal<Void>,
        fullElements: Driver<[SIFCLCollectionElement]>,
        itemCategory: Driver<ItemCategory>
    ) -> Driver<Route> {
        let close = didTapClose
            .map { Route.close }
            .asDriver(onErrorDriveWith: .never())
        
        let result = didTapContinue
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(fullElements)
            .withLatestFrom(itemCategory) { ($0, $1) }
            .compactMap { elements, itemCategory -> Route? in
                guard let item = elements.first(where: { $0.selected })?.item else { return nil }
                return .result((itemCategory, item))
            }
        
        return Driver
            .merge(close, result)
    }
    
    func makeElements(
        searchData: Driver<SearchData>,
        didScrollToBottom: Signal<Void>
    ) -> Driver<FetchElements> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int, data: SearchData) -> Driver<Page<[Item]>> {
            let terms: [String]? = {
                guard let textFilter = data.textFilter, !textFilter.isEmpty else { return nil }
                return [textFilter]
            }()
            
            return collectionsManager
                .obtainItems(
                    category: ItemCategory.DefaultLocalized().name(category: data.itemCategory),
                    attachment: {
                        switch data.attachment {
                        case .custom:
                            return .custom
                        case .internal:
                            return .internal
                        }
                    }(),
                    terms: terms,
                    page: page,
                    favorite: false
                )
                .trackActivity(page == 1 ? firstPageActivity : paginationActivity)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let firstPage = searchData
            .flatMapLatest { data -> Driver<Page<[Item]>> in
                fetch(page: 1, data: data)
            }
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<[Item]>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .withLatestFrom(searchData)
                    .compactMap { data -> (SearchData, PageInfo)? in
                        guard let lastPageInfo else { return nil }
                        return (data, lastPageInfo)
                    }
                    .filter { ($1.nextPage <= $1.total) && ($1.current != $1.total) }
                    .flatMapFirst { data, lastPageInfo -> Driver<Page<[Item]>> in
                        fetch(page: lastPageInfo.nextPage, data: data)
                    }
                    .startWith(firstPage)
            }
        
        let downloadedElements = downloadedPage
            .map { page -> FetchElements in
                let elements = page.elements.map { item -> SIFCLCollectionElement in
                    SIFCLCollectionElement(
                        item: item,
                        selected: false
                    )
                }
                
                return page.info.current == 1 ? .setup(elements) : .append(elements)
            }
        
        let reset = searchData
            .map { _ in FetchElements.setup([]) }
        
        return Driver
            .merge(downloadedElements, reset)
    }
    
    func makeFullElements(elements: Driver<FetchElements>) -> Driver<[SIFCLCollectionElement]> {
        elements
            .scan([]) { all, fetch -> [SIFCLCollectionElement] in
                switch fetch {
                case .setup(let elements):
                    return elements
                case .append(let elements):
                    return all + elements
                }
            }
    }
}
