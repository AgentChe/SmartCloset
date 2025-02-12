//
//  MCIViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 11.02.2025.
//

import RxSwift
import RxCocoa

final class MCIViewModel {
    enum Route {
        case close
        case database
        case gallery
        case takePhoto
    }
}

// MARK: Public
extension MCIViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didSelectMethod: Signal<MethodCreationItem>
    }
    
    struct Output {
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(
                didTapClose: input.didTapClose,
                didSelectMethod: input.didSelectMethod
            )
        )
    }
}

// MARK: Private
private extension MCIViewModel {
    func makeRoute(
        didTapClose: Signal<Void>,
        didSelectMethod: Signal<MethodCreationItem>
    ) -> Driver<Route> {
        let close = didTapClose
            .map { Route.close }
            .asDriver(onErrorDriveWith: .never())
        
        let create = didSelectMethod
            .map { method -> Route in
                switch method {
                case .database:
                    return .database
                case .gallery:
                    return .gallery
                case .takePhoto:
                    return .takePhoto
                }
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(close, create)
    }
}
