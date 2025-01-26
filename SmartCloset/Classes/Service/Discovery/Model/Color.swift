//
//  Color.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 26.01.2025.
//

struct Color: Codable {
    let id: String
    let code: String // hex: #FFC0CB
    let name: String
}

// MARK: Public
extension Color {
    static func make(response: Any) -> [Color]? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [[String: Any]]
        else { return nil }
        
        return body.compactMap { Color(json: $0) }
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["_id"] as? String,
            let code = json["code"] as? String,
            let name = json["color"] as? String
        else { return nil }
        
        self.id = id
        self.code = code
        self.name = name
    }
}
