//
//  InspirationTableElement.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 04.02.2025.
//

enum InspirationTableElement {
    case recommendations([InspirationTableRecommendationsElement])
    case itemCategories([ItemCategory])
    case collections(InspirationTableCollectionElement)
}

enum InspirationTableRecommendationsElement {
    case item(Item)
    case look(Look)
    
    static func array(recommendations: Recommendations) -> [InspirationTableRecommendationsElement]? {
        let items = recommendations.items
        let looks = recommendations.looks
        
        let maxIndex = max(items.count, looks.count) - 1
        
        guard maxIndex >= 0 else { return nil }
        
        var result = [InspirationTableRecommendationsElement]()
        
        for index in 0...maxIndex {
            if let item = items[safe: index] {
                result.append(.item(item))
            }
            
            if let look = looks[safe: index] {
                result.append(.look(look))
            }
        }
        
        return result
    }
}

struct InspirationTableCollectionElement {
    let leftItemCategory: ItemCategory
    let rightItemCategory: ItemCategory
    let gender: Gender
    let season: Season
}
