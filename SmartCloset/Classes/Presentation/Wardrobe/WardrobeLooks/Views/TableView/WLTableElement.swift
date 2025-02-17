//
//  WLTableElement.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 17.02.2025.
//

struct WLTableElement {
    enum Block {
        case favorites
        case allLooks
    }
    
    let block: Block
    let looks: [Look]
}
