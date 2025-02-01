//
//  SIFilterViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 01.02.2025.
//

import RxSwift
import RxCocoa

final class SIFilterViewModel {
    enum Route {
        case dismiss
        case selectCategory(Category?)
        case selectType(ItemType?)
        case selectColor(Color?)
        case selectMaterial(Material?)
    }
    
    private let inputData: Driver<Data>
    
    init(
        category: Category?,
        type: ItemType?,
        color: Color?,
        material: Material?
    ) {
        let data = Data(
            category: category,
            type: type,
            color: color,
            material: material
        )
        self.inputData = BehaviorRelay(value: data).asDriver()
    }
}

// MARK: Public
extension SIFilterViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didSelectCategory: Signal<Category?>
        let didSelectType: Signal<ItemType?>
        let didSelectColor: Signal<Color?>
        let didSelectMaterial: Signal<Material?>
        let didSelectElement: Signal<SIFilterTableElement>
    }
    
    struct Output {
        let route: Driver<Route>
        let elements: Driver<[SIFilterTableElement]>
    }
    
    func configure(input: Input) -> Output {
        let data = makeData(
            inputData: inputData,
            didSelectCategory: input.didSelectCategory,
            didSelectType: input.didSelectType,
            didSelectColor: input.didSelectColor,
            didSelectMaterial: input.didSelectMaterial
        )
        
        return Output(
            route: makeRoute(
                didTapClose: input.didTapClose,
                didSelectElement: input.didSelectElement,
                data: data
            ),
            elements: makeElements(data: data)
        )
    }
}

// MARK: Private
private extension SIFilterViewModel {
    struct Data {
        let category: Category?
        let type: ItemType?
        let color: Color?
        let material: Material?
    }
    
    func makeRoute(
        didTapClose: Signal<Void>,
        didSelectElement: Signal<SIFilterTableElement>,
        data: Driver<Data>
    ) -> Driver<Route> {
        let dismiss = didTapClose
            .map { Route.dismiss }
            .asDriver(onErrorDriveWith: .never())
        
        let select = didSelectElement
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(data) { ($0, $1) }
            .map { args -> Route in
                let (element, data) = args
                
                switch element {
                case .category(let category):
                    return .selectCategory(category)
                case .type(let type):
                    return .selectType(type)
                case .color(let color):
                    return .selectColor(color)
                case .material(let material):
                    return .selectMaterial(material)
                }
            }
        
        return Driver
            .merge(dismiss, select)
    }
    
    func makeElements(data: Driver<Data>) -> Driver<[SIFilterTableElement]> {
        data.map { data -> [SIFilterTableElement] in
            [
                .category(data.category),
                .type(data.type),
                .color(data.color),
                .material(data.material)
            ]
        }
    }
    
    func makeData(
        inputData: Driver<Data>,
        didSelectCategory: Signal<Category?>,
        didSelectType: Signal<ItemType?>,
        didSelectColor: Signal<Color?>,
        didSelectMaterial: Signal<Material?>
    ) -> Driver<Data> {
        let category = Driver
            .merge(
                inputData.map { $0.category },
                didSelectCategory.asDriver(onErrorDriveWith: .never())
            )
        let type = Driver
            .merge(
                inputData.map { $0.type },
                didSelectType.asDriver(onErrorDriveWith: .never())
            )
        let color = Driver
            .merge(
                inputData.map { $0.color },
                didSelectColor.asDriver(onErrorDriveWith: .never())
            )
        let material = Driver
            .merge(
                inputData.map { $0.material },
                didSelectMaterial.asDriver(onErrorDriveWith: .never())
            )
        
        return Driver
            .combineLatest(
                category,
                type,
                color,
                material
            ) { category, type, color, material -> Data in
                Data(
                    category: category,
                    type: type,
                    color: color,
                    material: material
                )
            }
    }
}
