//
//  InspirationTableElement.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 04.02.2025.
//

enum InspirationTableElement {
    case itemCategories([ItemCategory])
    case collections(InspirationTableCollectionElement)
}

struct InspirationTableCollectionElement {
    let leftItemCategory: ItemCategory
    let rightItemCategory: ItemCategory
    let gender: Gender
    let season: Season
}
