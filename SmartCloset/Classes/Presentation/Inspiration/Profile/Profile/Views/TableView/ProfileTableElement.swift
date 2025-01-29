//
//  ProfileTableElement.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import Foundation

enum ProfileTableElement {
    case name(String?)
    case avatar(URL?)
    case size(Size?)
    case gender(Gender?)
    case height(Height?)
    case occasions([Occasion]?)
    case seasons([Season]?)
}
