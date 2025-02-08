//
//  GenerateLookViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 07.02.2025.
//

import RxSwift
import RxCocoa

final class GenerateLookViewModel {
    enum Route {
        case close
        case complete(Look)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private let lookItems: Driver<CreateLookViewController.LookItems>
    
    private lazy var collectionsManager = CollectionsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(lookItems: CreateLookViewController.LookItems) {
        self.lookItems = BehaviorRelay(value: lookItems).asDriver()
    }
}

// MARK: Public
extension GenerateLookViewModel {
    struct Input {
        let didTapClose: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(
                didTapClose: input.didTapClose,
                lookItems: lookItems
            )
        )
    }
}

// MARK: Private
private extension GenerateLookViewModel {
    func makeRoute(
        didTapClose: Signal<Void>,
        lookItems: Driver<CreateLookViewController.LookItems>
    ) -> Driver<Route> {
        let close = didTapClose
            .map { Route.close }
            .asDriver(onErrorDriveWith: .never())
        
        let complete = lookItems
            .flatMapLatest { [weak self] lookItems -> Driver<Route> in
                guard let self else { return .never() }
                
                func source() -> Single<Look> {
                    collectionsManager
                        .createLook(
                            topItemId: lookItems.tops?.id,
                            bottomItemId: lookItems.bottoms?.id,
                            shoesItemId: lookItems.shoes?.id,
                            bagsItemId: lookItems.bags?.id,
                            accessoriesItemId: lookItems.accessories?.id
                        )
                        .map { look -> Look in
                            guard let look  else { throw ContentError(.notContent) }
                            return look
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    tryAgain?(error) ?? .empty()
                }
                
                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .asDriver(onErrorDriveWith: .never())
                    .map { Route.complete($0) }
            }
        
        return Driver
            .merge(close, complete)
    }
}
