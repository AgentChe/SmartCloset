//
//  CLRViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 08.02.2025.
//

import RxSwift
import RxCocoa

final class CLRViewModel {
    enum Route {
        case close
        case wardrobe
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private let look: Driver<Look>
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var collectionsManager = CollectionsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(look: Look) {
        self.look = BehaviorRelay(value: look).asDriver()
    }
}

// MARK: Public
extension CLRViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didTapAddToWardrobe: Signal<Void>
    }
    
    struct Output {
        let look: Driver<Look>
        let route: Driver<Route>
        let activity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        Output(
            look: look,
            route: makeRoute(
                didTapClose: input.didTapClose,
                didTapAddToWardrobe: input.didTapAddToWardrobe,
                look: look
            ),
            activity: activity.asDriver()
        )
    }
}

// MARK: Private
private extension CLRViewModel {
    func makeRoute(
        didTapClose: Signal<Void>,
        didTapAddToWardrobe: Signal<Void>,
        look: Driver<Look>
    ) -> Driver<Route> {
        let close = didTapClose
            .map { Route.close }
            .asDriver(onErrorDriveWith: .never())
        
        let wardrobe = didTapAddToWardrobe
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(look)
            .flatMapLatest { [weak self] look -> Driver<Route> in
                guard let self else { return .never() }
                
                func source() -> Single<Void> {
                    collectionsManager
                        .addWardrobe(lookId: look.id)
                        .map { look -> Void in
                            guard look != nil else {
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
                    .trackActivity(activity)
                    .map { Route.wardrobe }
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(close, wardrobe)
    }
}
