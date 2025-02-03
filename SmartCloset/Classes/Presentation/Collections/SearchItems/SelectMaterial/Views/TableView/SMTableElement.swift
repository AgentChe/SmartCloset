//
//  SMTableElement.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 02.02.2025.
//

final class SMTableElement {
    let material: Material
    var marked: Bool
    
    init(material: Material, marked: Bool) {
        self.material = material
        self.marked = marked
    }
}
