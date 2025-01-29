//
//  InspirationViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import RxSwift
import RxCocoa

final class InspirationViewModel {
    enum Route {
        case settings
    }
}

// MARK: Public
extension InspirationViewModel {
    struct Input {
        let didTapSettings: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(
                didTapSettings: input.didTapSettings
            )
        )
    }
}

// MARK: Private
private extension InspirationViewModel {
    func makeRoute(
        didTapSettings: Signal<Void>
    ) -> Driver<Route> {
        let settings = didTapSettings
            .map { Route.settings }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(settings)
    }
}
