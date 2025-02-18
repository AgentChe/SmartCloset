//
//  WICollectionElement.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 18.02.2025.
//

final class WICollectionElement {
    let item: Item
    var favorite: Bool
    
    init(item: Item, favorite: Bool) {
        self.item = item
        self.favorite = favorite
    }
}
