//
//  Category.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 26.01.2025.
//

struct Category: Codable {
    let id: String
    let name: String
}

// MARK: Public
extension Category {
    static func make(response: Any) -> [Category]? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [[String: Any]]
        else { return nil }
        
        return body.compactMap { Category(json: $0) }
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
