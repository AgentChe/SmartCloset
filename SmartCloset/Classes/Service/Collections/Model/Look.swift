//
//  Look.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 30.01.2025.
//

import Foundation

struct Look {
    let id: String
    let top: Item?
    let bottom: Item?
    let shoes: Item?
    let bags: Item?
    let accessories: Item?
    let isFavorite: Bool
}

// MARK: Public
extension Look {
    static func make(response: Any) -> Page<[Look]>? {
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
    
    // TODO
    init?(response: Any) {
        self = Look(
            id: UUID().uuidString,
            top: Item(
                id: UUID().uuidString,
                name: "Black Kimono with Fringe",
                image: URL(string: "https://nyc3.digitaloceanspaces.com/kcs/smart_closet/fba321b8c7aff63f629c1c86fd2784c9_image.png")!,
                category: "Tops",
                type: "Kimono",
                color: Color(code: "#000000", name: "black"),
                material: "fabric",
                comments: nil,
                isFavorite: false
            ),
            bottom: Item(
                id: UUID().uuidString,
                name: "Black feather skirt",
                image: URL(string: "https://nyc3.digitaloceanspaces.com/kcs/smart_closet/b6a1c34edb53f2abcff6994838b933d6_8945836C-9BA1-419F-862C-81D70A9F0029.png")!,
                category: "Bottoms",
                type: "Skirt",
                color: Color(code: "#000000", name: "black"),
                material: "feather",
                comments: nil,
                isFavorite: false
            ),
            shoes: nil,
            bags: Item(
                id: UUID().uuidString,
                name: "Black embellished handbag",
                image: URL(string: "https://nyc3.digitaloceanspaces.com/kcs/smart_closet/b6a1c34edb53f2abcff6994838b933d6_8945836C-9BA1-419F-862C-81D70A9F0029.png")!,
                category: "Bags",
                type: "Handbag",
                color: Color(code: "#000000", name: "black"),
                material: "synthetic",
                comments: nil,
                isFavorite: false
            ),
            accessories: nil,
            isFavorite: false
        )
        
//        guard
//            let json = response as? [String: Any],
//            let body = json["body"] as? [String: Any],
//            let look = Look(json: body)
//        else { return nil }
//        
//        self = look
    }
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? String else { return nil }
        
        self.id = id
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
