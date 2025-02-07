//
//  CanvasViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 06.02.2025.
//

import RxSwift
import RxCocoa

final class CanvasViewModel {
    enum Route {
        case createLook(ItemCategory)
    }
    
    private lazy var profileManager = ProfileManager()
}

// MARK: Public
extension CanvasViewModel {
    struct Input {
        let didTapItemCategory: Signal<ItemCategory>
    }
    
    struct Output {
        let season: Driver<Season>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            season: makeSeason(),
            route: makeRoute(didTapItemCategory: input.didTapItemCategory)
        )
    }
}

// MARK: Private
private extension CanvasViewModel {
    func makeSeason() -> Driver<Season> {
        let triggers = Signal
            .merge(
                ProfileMediator.shared.didUpdateProfile.map { _ in Void() },
                ProfileMediator.shared.didUpdateSeason.map { _ in Void() }
            )
            .startWith(())
        
        return triggers
            .flatMapLatest { [weak self] void -> Driver<Season> in
                guard let self else { return .never() }
                
                return profileManager
                    .obtainProfile(forceUpdate: false)
                    .map { $0?.season ?? .autumn }
                    .asDriver(onErrorDriveWith: .never())
            }
    }
    
    func makeRoute(didTapItemCategory: Signal<ItemCategory>) -> Driver<Route> {
        let createLook = didTapItemCategory
            .map { Route.createLook($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(createLook)
    }
}
