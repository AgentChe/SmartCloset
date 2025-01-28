//
//  OTableElement.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 28.01.2025.
//

final class OTableElement {
    enum Entity {
        case color(Color)
        case occasion(Occasion)
        case season(Season)
    }
    
    let entity: Entity
    var marked: Bool
    
    init(entity: Entity, marked: Bool = false) {
        self.entity = entity
        self.marked = marked
    }
}
