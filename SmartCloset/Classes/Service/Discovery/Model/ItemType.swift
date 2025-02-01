//
//  ItemType.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 26.01.2025.
//

struct ItemType: Codable {
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
        guard let name = json["name"] as? String else { return nil }
        
        self.name = name
    }
}
