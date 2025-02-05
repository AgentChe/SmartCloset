//
//  RecommendationsCollectionElement.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 05.02.2025.
//

enum RecommendationsCollectionElement {
    case item(Item)
    case look(Look)
    
    static func array(recommendations: Recommendations) -> [RecommendationsCollectionElement]? {
        let items = recommendations.items
        let looks = recommendations.looks
        
        let maxIndex = max(items.count, looks.count) - 1
        
        guard maxIndex >= 0 else { return nil }
        
        var result = [RecommendationsCollectionElement]()
        
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
