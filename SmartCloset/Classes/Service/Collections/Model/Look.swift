//
//  Look.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 30.01.2025.
//

struct Look {
    let id: String
    let name: String
    let top: Item?
    let bottom: Item?
    let shoes: Item?
    let bags: Item?
    let accessories: Item?
    let isFavorite: Bool
}

// MARK: Public
extension Look {
    static func make(response: Any) -> Page<Look>? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let pageInfo: PageInfo = {
                guard let pagination = body["pagination"] as? [String: Any] else { return nil }
                return PageInfo(json: pagination)
            }(),
            let array = body["looks"] as? [[String: Any]]
        else { return nil }
        
        let looks = array.compactMap { Look(json: $0) }
        
        return Page(info: pageInfo, elements: looks)
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String
        else { return nil }
        
        self.id = id
        self.name = name
        self.top = {
            guard let itemJSON = json["item_top"] as? [String: Any] else { return nil }
            return Item(json: itemJSON)
        }()
        self.bottom = {
            guard let itemJSON = json["item_bottom"] as? [String: Any] else { return nil }
            return Item(json: itemJSON)
        }()
        self.shoes = {
            guard let itemJSON = json["item_shoes"] as? [String: Any] else { return nil }
            return Item(json: itemJSON)
        }()
        self.bags = {
            guard let itemJSON = json["item_bags"] as? [String: Any] else { return nil }
            return Item(json: itemJSON)
        }()
        self.accessories = {
            guard let itemJSON = json["item_accessories"] as? [String: Any] else { return nil }
            return Item(json: itemJSON)
        }()
        self.isFavorite = json["is_favorite"] as? Bool ?? false
    }
}
