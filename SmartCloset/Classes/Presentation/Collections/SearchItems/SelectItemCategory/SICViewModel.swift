//
//  SICViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 02.02.2025.
//

import RxSwift
import RxCocoa

final class SICViewModel {
    enum Route {
        case dismiss
        case selectItemType(ItemCategory)
    }
}

// MARK: Public
extension SICViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didSelect: Signal<ItemCategory>
    }
    
    struct Output {
        let elements: Driver<[ItemCategory]>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            elements: makeElements(),
            route: makeRoute(
                didTapClose: input.didTapClose,
                didSelect: input.didSelect
            )
        )
    }
}

// MARK: Private
private extension SICViewModel {
    func makeElements() -> Driver<[ItemCategory]> {
        Single
            .create { single in
                single(.success(ItemCategory.allCases))
                
                return Disposables.create()
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeRoute(
        didTapClose: Signal<Void>,
        didSelect: Signal<ItemCategory>
    ) -> Driver<Route> {
        let dismiss = didTapClose
            .map { Route.dismiss }
            .asDriver(onErrorDriveWith: .never())
        
        let select = didSelect
            .map { Route.selectItemType($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(dismiss, select)
    }
}
