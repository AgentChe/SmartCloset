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
        case openFilter(SIFilterViewController.Data)
    }
    
    private lazy var collectionsManager = CollectionsManager()
}

// MARK: Public
extension SearchItemsViewModel {
    struct Input {
        let didTapFilter: Signal<Void>
        let appliedFilter: Signal<SIFilterViewController.Data>
    }
    
    struct Output {
        let route: Driver<Route>
        let selectedFilterItemsCount: Driver<Int>
    }
    
    func configure(input: Input) -> Output {
        let filter = makeFilter(appliedFilter: input.appliedFilter)
        
        return Output(
            route: makeRoute(
                didTapFilter: input.didTapFilter,
                filter: filter
            ),
            selectedFilterItemsCount: makeSelectedFilterItemsCount(filter: filter)
        )
    }
}

// MARK: Private
private extension SearchItemsViewModel {
    func makeRoute(
        didTapFilter: Signal<Void>,
        filter: Driver<SIFilterViewController.Data>
    ) -> Driver<Route> {
        let openFilter = didTapFilter
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(filter)
            .map { Route.openFilter($0) }
        
        return Driver
            .merge(openFilter)
    }
    
    func makeSelectedFilterItemsCount(filter: Driver<SIFilterViewController.Data>) -> Driver<Int> {
        filter
            .map { data -> Int in
                var count = 0
                if data.category != nil { count += 1 }
                if data.type != nil { count += 1 }
                if data.color != nil { count += 1 }
                if data.material != nil { count += 1 }
                return count
            }
    }
    
    func makeFilter(appliedFilter: Signal<SIFilterViewController.Data>) -> Driver<SIFilterViewController.Data> {
        appliedFilter
            .asDriver(onErrorDriveWith: .never())
            .startWith(SIFilterViewController.Data(
                category: nil,
                type: nil,
                color: nil,
                material: nil)
            )
    }
}
