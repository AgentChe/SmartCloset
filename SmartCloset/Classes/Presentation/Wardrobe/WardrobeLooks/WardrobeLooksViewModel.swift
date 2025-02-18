//
//  WardrobeLooksViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 16.02.2025.
//

import RxSwift
import RxCocoa

final class WardrobeLooksViewModel {
    enum Route {
        case openLook(Look)
        case openFavorites
        case openAll
        case createLook
    }
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var collectionsManager = CollectionsManager()
}

// MARK: Public
extension WardrobeLooksViewModel {
    struct Input {
        let didForceUpdate: Signal<Void>
        let didSelect: Signal<Look>
        let didTapSeeMore: Signal<WLTableElement.Block>
        let didTapCreateLook: Signal<Void>
    }
    
    struct Output {
        let elements: Driver<[WLTableElement]>
        let activity: Driver<Bool>
        let isEmpty: Driver<Bool>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let elements =  makeElements(didForceUpdate: input.didForceUpdate)
        
        return Output(
            elements: elements,
            activity: activity.asDriver(),
            isEmpty: makeIsEmpty(elements: elements),
            route: makeRoute(
                didSelect: input.didSelect,
                didTapSeeMore: input.didTapSeeMore,
                didTapCreateLook: input.didTapCreateLook
            )
        )
    }
}

// MARK: Private
private extension WardrobeLooksViewModel {
    func makeIsEmpty(elements: Driver<[WLTableElement]>) -> Driver<Bool> {
        elements
            .map { $0.isEmpty }
            .startWith(false)
    }
    
    func makeElements(didForceUpdate: Signal<Void>) -> Driver<[WLTableElement]> {
        let trigger = Signal<Void>
            .merge(
                CollectionsMediator.shared.lookEdited.map { _ in Void() },
                CollectionsMediator.shared.lookCreated.map { _ in Void() },
                CollectionsMediator.shared.lookDeleted.map { _ in Void() },
                CollectionsMediator.shared.lookAddFavorite.map { _ in Void() },
                CollectionsMediator.shared.lookRemoveFromFavorite.map { _ in Void() },
                CollectionsMediator.shared.looksDidChangeWardrobe.map { _ in Void() },
                didForceUpdate
            )
            .startWith(())
            .asDriver(onErrorDriveWith: .never())
        
        return trigger
            .flatMapLatest { [weak self] void -> Driver<[WLTableElement]> in
                guard let self else { return .never() }
                
                func source() -> Driver<([Look], [Look])> {
                    let favorites = collectionsManager
                        .obtainLooks(attachment: .custom, page: 1, limit: 3, favorite: true)
                        .map { $0?.elements ?? [] }
                        .asDriver(onErrorJustReturn: [])
                    
                    let all = collectionsManager
                        .obtainLooks(attachment: .wardrobe, page: 1, limit: 3, favorite: nil)
                        .map { $0?.elements ?? [] }
                        .asDriver(onErrorJustReturn: [])
                    
                    return Driver
                        .zip(favorites, all)
                }
                
                return source()
                    .trackActivity(activity)
                    .map { favorites, all -> [WLTableElement] in
                        var result = [WLTableElement]()
                        
                        if !favorites.isEmpty {
                            let elements = WLTableElement(block: .favorites, looks: favorites)
                            result.append(elements)
                        }
                        
                        if !all.isEmpty {
                            let elements = WLTableElement(block: .allLooks, looks: all)
                            result.append(elements)
                        }
                        
                        return result
                    }
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func makeRoute(
        didSelect: Signal<Look>,
        didTapSeeMore: Signal<WLTableElement.Block>,
        didTapCreateLook: Signal<Void>
    ) -> Driver<Route> {
        let openLook = didSelect
            .map { Route.openLook($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let openList = didTapSeeMore
            .map { block in
                switch block {
                case .favorites:
                    return Route.openFavorites
                case .allLooks:
                    return Route.openAll
                }
            }
            .asDriver(onErrorDriveWith: .never())
        
        let createLook = didTapCreateLook
            .map { Route.createLook }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(openLook, openList, createLook)
    }
}
