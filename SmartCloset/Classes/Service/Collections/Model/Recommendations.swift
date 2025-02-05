//
//  Recommendations.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 05.02.2025.
//

struct Recommendations {
    let items: [Item]
    let looks: [Look]
}

// MARK: Public
extension Recommendations {
    static func map(response: Any) -> Page<Recommendations>? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let pageInfo: PageInfo = {
                guard let pagination = body["pagination"] as? [String: Any] else { return nil }
                return PageInfo(json: pagination)
            }()
        else { return nil }
        
        let itemsArray = body["items"] as? [[String: Any]]
        let items = itemsArray?.compactMap { Item(json: $0) } ?? []
        
        let looksArray = body["looks"] as? [[String: Any]]
        let looks = looksArray?.compactMap { Look(json: $0) } ?? []
        
        let recommendations = Recommendations(items: items, looks: looks)
        
        return Page(info: pageInfo, elements: recommendations)
    }
}
