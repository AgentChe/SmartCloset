//
//  Item.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 30.01.2025.
//

import Foundation

struct Item {
    let id: String
    let name: String
    let image: URL
    let category: String?
    let type: String?
    let color: Color?
    let material: String?
    let comments: String?
    let isFavorite: Bool
}

// MARK: Mark
extension Item {
    static func map(response: Any) -> Page<Item>? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let pageInfo: PageInfo = {
                guard let pagination = body["pagination"] as? [String: Any] else { return nil }
                return PageInfo(json: pagination)
            }(),
            let array = body["items"] as? [[String: Any]]
        else { return nil }
        
        let items = array.compactMap { Item(json: $0) }
        
        return Page(info: pageInfo, elements: items)
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String,
            let image: URL = {
                guard let string = json["image"] as? String else { return nil }
                return URL(string: string)
            }()
        else { return nil }
        
        self.id = id
        self.name = name
        self.image = image
        self.category = json["category"] as? String
        self.type = json["type"] as? String
        self.color = {
            guard let dict = json["color"] as? [String: String], let data = dict.first else { return nil }
            return Color(code: data.1, name: data.0)
        }()
        self.material = json["material"] as? String
        self.comments = json["comments"] as? String
        self.isFavorite = json["is_favorite"] as? Bool ?? false
    }
}
