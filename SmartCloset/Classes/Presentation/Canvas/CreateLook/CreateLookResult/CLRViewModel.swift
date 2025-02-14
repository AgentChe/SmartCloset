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
    
    private let look: Driver<Look>
    
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
    }
    
    func configure(input: Input) -> Output {
        Output(
            look: look,
            route: makeRoute(
                didTapClose: input.didTapClose,
                didTapAddToWardrobe: input.didTapAddToWardrobe,
                look: look
            )
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
            .map { Route.wardrobe }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(close, wardrobe)
    }
}
