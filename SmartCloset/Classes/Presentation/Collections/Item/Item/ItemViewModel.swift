//
//  ItemViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 04.02.2025.
//

import RxSwift
import RxCocoa

final class ItemViewModel {
    private let item: Driver<Item>
    
    init(item: Item) {
        self.item = BehaviorRelay(value: item).asDriver()
    }
}

// MARK: Public
extension ItemViewModel {
    struct Input {}
    
    struct Output {
        let elements: Driver<[ItemTableElement]>
    }
    
    func configure(input: Input) -> Output {
        Output(
            elements: makeElements(item: item)
        )
    }
}

// MARK: Private
private extension ItemViewModel {
    func makeElements(item: Driver<Item>) -> Driver<[ItemTableElement]> {
        item.map { item -> [ItemTableElement] in
            var result = [ItemTableElement]()
            
            result.append(.image(item.image))
            
            if let category = item.category {
                result.append(.textField("Item.Category".localized, category))
            }
            
            if let type = item.type {
                result.append(.textField("Item.Type".localized, type))
            }
            
            if let color = item.color {
                result.append(.color(color))
            }
            
            if let material = item.material {
                result.append(.textField("Item.Fabric".localized, material))
            }
            
            if let comments = item.comments {
                result.append(.textField("Item.Comments".localized, comments))
            }
            
            return result
        }
    }
}
