//
//  Color.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 26.01.2025.
//

import UIKit

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

// MARK: Public (Additional)
extension Color {
    struct DecodeBackendHex {
        func uicolor(code: String) -> UIColor? {
            var hexCleaned = code
            
            if hexCleaned.hasPrefix("#") {
                hexCleaned.removeFirst()
            }
            
            guard hexCleaned.count == 6 else { return nil }
            
            var rgb: UInt64 = 0
            Scanner(string: hexCleaned).scanHexInt64(&rgb)
            
            let red = CGFloat(Int((rgb >> 16) & 0xFF))
            let green = CGFloat(Int((rgb >> 8) & 0xFF))
            let blue = CGFloat(Int(rgb & 0xFF))
            
            return UIColor(integralRed: red, green: green, blue: blue)
        }
    }
}
