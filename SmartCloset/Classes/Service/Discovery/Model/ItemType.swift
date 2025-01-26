//
//  ItemType.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 26.01.2025.
//

struct ItemType: Codable {
    let id: String
    let name: String
}

// MARK: Public
extension ItemType {
    static func make(response: Any) -> [ItemType]? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [[String: Any]]
        else { return nil }
        
        return body.compactMap { ItemType(json: $0) }
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["_id"] as? String,
            let name = json["name"] as? String
        else { return nil }
        
        self.id = id
        self.name = name
    }
}
