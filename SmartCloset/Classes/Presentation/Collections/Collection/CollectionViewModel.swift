//
//  CollectionViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 10.02.2025.
//

import RxSwift
import RxCocoa

final class CollectionViewModel {
    enum Route {
        case dismiss
        case edit(Collection)
        case openLook(Look)
    }
    
    private let initialCollection: Driver<Collection>
    
    init(collection: Collection) {
        self.initialCollection = BehaviorRelay(value: collection).asDriver()
    }
}

// MARK: Public
extension CollectionViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didTapEdit: Signal<Void>
        let didSelectLook: Signal<Look>
    }
    
    struct Output {
        let route: Driver<Route>
        let elements: Driver<[Look]>
        let name: Driver<String>
    }
    
    func configure(input: Input) -> Output {
        let collection = makeCollection(initial: initialCollection)
        
        return Output(
            route: makeRoute(
                didTapClose: input.didTapClose,
                didTapEdit: input.didTapEdit,
                collection: collection,
                didSelectLook: input.didSelectLook
            ),
            elements: collection.map { $0.looks },
            name: collection.map { $0.name }
        )
    }
}

// MARK: Private
private extension CollectionViewModel {
    func makeRoute(
        didTapClose: Signal<Void>,
        didTapEdit: Signal<Void>,
        collection: Driver<Collection>,
        didSelectLook: Signal<Look>
    ) -> Driver<Route> {
        let dismiss = didTapClose
            .map { Route.dismiss }
            .asDriver(onErrorDriveWith: .never())
        
        let edit = didTapEdit
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(collection)
            .map { Route.edit($0) }
        
        let openLook = didSelectLook
            .map { Route.openLook($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(dismiss, edit, openLook)
    }
    
    func makeCollection(initial: Driver<Collection>) -> Driver<Collection> {
        let updated = CollectionsMediator.shared
            .collectionEdited
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(initial) { ($0, $1) }
            .compactMap { edited, initial -> Collection? in
                edited.id == initial.id ? edited : initial
            }
        
        return Driver
            .merge(updated, initial)
    }
}
