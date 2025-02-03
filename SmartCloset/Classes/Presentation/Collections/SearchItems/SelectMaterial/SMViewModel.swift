//
//  SMViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 02.02.2025.
//

import RxSwift
import RxCocoa

final class SMViewModel {
    enum Route {
        case dismiss
        case complete(Material)
    }
    
    private let initialMaterial: Driver<Material?>
    
    init(material: Material?) {
        self.initialMaterial = BehaviorRelay(value: material).asDriver()
    }
}

// MARK: Public
extension SMViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didTapSave: Signal<Void>
    }
    
    struct Output {
        let elements: Driver<[SMTableElement]>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let elements = makeElements(initialMaterial: initialMaterial)
        
        return Output(
            elements: elements,
            route: makeRoute(
                didTapClose: input.didTapClose,
                didTapSave: input.didTapSave,
                elements: elements
            )
        )
    }
}

// MARK: Private
private extension SMViewModel {
    func makeElements(initialMaterial: Driver<Material?>) -> Driver<[SMTableElement]> {
        initialMaterial
            .map { initialMaterial -> [SMTableElement] in
                Material.Fabric().list()
                    .map { material -> SMTableElement in
                        SMTableElement(
                            material: material,
                            marked: material == initialMaterial
                        )
                    }
            }
    }
    
    func makeRoute(
        didTapClose: Signal<Void>,
        didTapSave: Signal<Void>,
        elements: Driver<[SMTableElement]>
    ) -> Driver<Route> {
        let dismiss = didTapClose
            .map { Route.dismiss }
            .asDriver(onErrorDriveWith: .never())
        
        let complete = didTapSave
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(elements)
            .compactMap { elements -> Material? in
                elements.first(where: { $0.marked })?.material
            }
            .map { Route.complete($0) }
        
        return Driver
            .merge(dismiss, complete)
    }
}
