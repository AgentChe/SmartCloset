//
//  CCSLLooksCollectionElement.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 10.02.2025.
//

final class CCSLLooksCollectionElement {
    let look: Look
    var marked: Bool
    
    init(look: Look, marked: Bool) {
        self.look = look
        self.marked = marked
    }
}
