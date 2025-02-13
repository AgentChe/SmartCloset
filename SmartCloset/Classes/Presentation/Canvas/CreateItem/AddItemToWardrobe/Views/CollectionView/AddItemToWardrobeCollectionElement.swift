//
//  AddItemToWardrobeCollectionElement.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 13.02.2025.
//

final class AddItemToWardrobeCollectionElement {
    let item: Item
    var marked: Bool
    
    init(item: Item, marked: Bool) {
        self.item = item
        self.marked = marked
    }
}
