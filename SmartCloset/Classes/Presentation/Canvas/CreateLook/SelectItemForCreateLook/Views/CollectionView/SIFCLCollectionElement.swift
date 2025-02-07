//
//  SIFCLCollectionElement.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 06.02.2025.
//

final class SIFCLCollectionElement {
    let item: Item
    var selected: Bool
    
    init(item: Item, selected: Bool) {
        self.item = item
        self.selected = selected
    }
}
