//
//  SCViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 03.02.2025.
//

import RxSwift
import RxCocoa

final class SCViewModel {
    enum Route {
        case dismiss
        case complete(Color)
    }
    
    private let initialColor: Driver<Color?>
    
    private lazy var discoveryManager = DiscoveryManager()
    
    init(color: Color?) {
        self.initialColor = BehaviorRelay(value: color).asDriver()
    }
}

// MARK: Public
extension SCViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didTapSave: Signal<Void>
    }
    
    struct Output {
        let elements: Driver<[SCTableElement]>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let elements = makeElements(initialColor: initialColor)
        
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
private extension SCViewModel {
    func makeElements(initialColor: Driver<Color?>) -> Driver<[SCTableElement]> {
        let colors = discoveryManager
            .obtainColors(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
        
        return Driver
            .combineLatest(colors, initialColor)
            .map { colors, initialColor -> [SCTableElement] in
                (colors ?? [])
                    .map { color -> SCTableElement in
                        SCTableElement(
                            color: color,
                            marked: color == initialColor
                        )
                    }
            }
    }
    
    func makeRoute(
        didTapClose: Signal<Void>,
        didTapSave: Signal<Void>,
        elements: Driver<[SCTableElement]>
    ) -> Driver<Route> {
        let dismiss = didTapClose
            .map { Route.dismiss }
            .asDriver(onErrorDriveWith: .never())
        
        let complete = didTapSave
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(elements)
            .compactMap { elements -> Color? in
                elements.first(where: { $0.marked })?.color
            }
            .map { Route.complete($0) }
        
        return Driver
            .merge(dismiss, complete)
    }
}
