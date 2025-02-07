//
//  CLItemsCollectionElement.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 07.02.2025.
//

enum CLItemsCollectionElement {
    case selectItem(ItemCategory)
    case item(CLItemsCollectionItemElement)
}

final class CLItemsCollectionItemElement {
    let item: Item
    var selected: Bool
    
    init(item: Item, selected: Bool) {
        self.item = item
        self.selected = selected
    }
}
