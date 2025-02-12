//
//  CITableElement.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 11.02.2025.
//

import UIKit

enum CITableElement {
    case image(CITableImageElement)
    case name
    case category(ItemCategory?)
    case type(ItemType?)
    case color(Color?)
    case material(Material?)
    case comments
}

enum CITableImageElement {
    case placeholder
    case url(URL)
}
