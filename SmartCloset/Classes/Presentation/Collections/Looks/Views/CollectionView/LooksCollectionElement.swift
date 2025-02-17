//
//  LooksCollectionElement.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 17.02.2025.
//

final class LooksCollectionElement {
    let look: Look
    var favorite: Bool
    
    init(look: Look, favorite: Bool) {
        self.look = look
        self.favorite = favorite
    }
}
