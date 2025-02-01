//
//  SearchItemsViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 01.02.2025.
//

import RxSwift
import RxCocoa

final class SearchItemsViewModel {
    enum Route {
        case filter
    }
    
    private lazy var collectionsManager = CollectionsManager()
}

// MARK: Public
extension SearchItemsViewModel {
    struct Input {
        let didTapFilter: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(didTapFilter: input.didTapFilter)
        )
    }
}

// MARK: Private
private extension SearchItemsViewModel {
    func makeRoute(didTapFilter: Signal<Void>) -> Driver<Route> {
        let filter = didTapFilter
            .map { Route.filter }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(filter)
    }
}
