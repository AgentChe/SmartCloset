//
//  LooksViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 17.02.2025.
//

import RxSwift
import RxCocoa

final class LooksViewModel {
    enum Action {
        case setup([LooksCollectionElement])
        case append([LooksCollectionElement])
        case route(Route)
        case changeFavorite(String, Bool)
    }
    
    enum Route {
        case openLook(Look)
        case paygate
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    
    private lazy var collectionsManager = CollectionsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    private let searchData: Driver<SearchData>
    
    init(attachment: GetCollectionsRequest.Attachment, favorite: Bool?) {
        let data = SearchData(attachment: attachment, favorite: favorite)
        searchData = BehaviorRelay(value: data).asDriver()
    }
}

// MARK: Public
extension LooksViewModel {
    struct Input {
        let didScrollToBottom: Signal<Void>
        let didTapFavorite: Signal<LooksCollectionElement>
        let didSelectLook: Signal<Look>
    }
    
    struct Output {
        let action: Driver<Action>
        let firstPageActivity: Driver<Bool>
        let paginationActivity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(
                didScrollToBottom: input.didScrollToBottom,
                searchData: searchData,
                didSelectLook: input.didSelectLook,
                didTapFavorite: input.didTapFavorite
            ),
            firstPageActivity: firstPageActivity.asDriver(),
            paginationActivity: paginationActivity.asDriver()
        )
    }
}

// MARK: Private
private extension LooksViewModel {
    struct FetchElementsResult {
        let elements: [LooksCollectionElement]
        let isFirstPage: Bool
    }
    
    struct SearchData {
        let attachment: GetCollectionsRequest.Attachment
        let favorite: Bool?
    }
    
    func makeAction(
        didScrollToBottom: Signal<Void>,
        searchData: Driver<SearchData>,
        didSelectLook: Signal<Look>,
        didTapFavorite: Signal<LooksCollectionElement>
    ) -> Driver<Action> {
        let elements = makeElements(
            didScrollToBottom: didScrollToBottom,
            searchData: searchData
        )
        
        let setupOrAppend = elements
            .map { result -> Action in
                result.isFirstPage ? .setup(result.elements) : .append(result.elements)
            }
        
        let route = makeRoute(
            didSelectLook: didSelectLook,
            didTapFavorite: didTapFavorite
        )
        .map { Action.route($0) }
        
        let favorite = makeFavorite(didTapFavorite: didTapFavorite)
        
        return Driver
            .merge(setupOrAppend, route, favorite)
    }
    
    func makeElements(
        didScrollToBottom: Signal<Void>,
        searchData: Driver<SearchData>
    ) -> Driver<FetchElementsResult> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int, searchData: SearchData) -> Driver<Page<[Look]>> {
            collectionsManager
                .obtainLooks(
                    attachment: searchData.attachment,
                    page: page,
                    favorite: searchData.favorite
                )
                .trackActivity(page == 1 ? firstPageActivity : paginationActivity)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let trigger = Signal<Void>
            .merge(
                CollectionsMediator.shared.lookEdited.map { _ in Void() },
                CollectionsMediator.shared.lookCreated.map { _ in Void() },
                CollectionsMediator.shared.lookDeleted.map { _ in Void() }
            )
            .startWith(())
        
        let firstPage = trigger
            .withLatestFrom(searchData)
            .flatMapLatest { searchData -> Driver<Page<[Look]>> in
                fetch(page: 1, searchData: searchData)
            }
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<[Look]>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .withLatestFrom(searchData)
                    .compactMap { searchData -> (SearchData, PageInfo)? in
                        guard let lastPageInfo else { return nil }
                        return (searchData, lastPageInfo)
                    }
                    .filter { ($1.nextPage <= $1.total) && ($1.current != $1.total) }
                    .flatMapFirst { searchData, lastPageInfo -> Driver<Page<[Look]>> in
                        fetch(page: lastPageInfo.nextPage, searchData: searchData)
                    }
                    .startWith(firstPage)
            }
        
        return downloadedPage
            .map { page -> FetchElementsResult in
                let elements = page.elements.map { look -> LooksCollectionElement in
                    LooksCollectionElement(
                        look: look,
                        favorite: look.isFavorite
                    )
                }
                return FetchElementsResult(
                    elements: elements,
                    isFirstPage: page.info.current == 1
                )
            }
    }
    
    func makeRoute(
        didSelectLook: Signal<Look>,
        didTapFavorite: Signal<LooksCollectionElement>
    ) -> Driver<Route> {
        let openLook = didSelectLook
            .map { Route.openLook($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let paygate = didTapFavorite
            .filter { _ in !SessionManager().hasActiveSubscriptions() }
            .map { _ in Route.paygate }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(openLook, paygate)
    }
    
    func makeFavorite(didTapFavorite: Signal<LooksCollectionElement>) -> Driver<Action> {
        let tap = didTapFavorite
            .filter { _ in SessionManager().hasActiveSubscriptions() }
            .flatMapLatest { [weak self] element -> Driver<Action> in
                guard let self else { return .never() }
                
                func source() -> Single<Action> {
                    let id = element.look.id
                    
                    let single = element.favorite
                        ? collectionsManager.removeFavorite(id: id, tab: .looks)
                        : collectionsManager.addFavorite(id: id, tab: .looks)
                    
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
                    .lookAddFavorite
                    .map { Action.changeFavorite($0, true) },
                CollectionsMediator.shared
                    .lookRemoveFromFavorite
                    .map { Action.changeFavorite($0, false) }
            )
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(tap, update)
    }
}
