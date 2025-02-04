//
//  SICollectionElement.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 03.02.2025.
//

final class SICollectionElement {
    let item: Item
    var favorite: Bool
    
    init(item: Item, favorite: Bool) {
        self.item = item
        self.favorite = favorite
    }
}
