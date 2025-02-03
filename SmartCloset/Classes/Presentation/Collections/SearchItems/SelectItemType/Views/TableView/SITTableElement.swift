//
//  SITTableElement.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 02.02.2025.
//

final class SITTableElement {
    let itemType: ItemType
    var marked: Bool
    
    init(itemType: ItemType, marked: Bool) {
        self.itemType = itemType
        self.marked = marked
    }
}
