//
//  Image.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import Foundation

struct Image {
    let url: URL?
}

// MARK: Public
extension Image {
    init(response: Any) {
        url = {
            guard
                let json = response as? [String: Any],
                let body = json["body"] as? [String: Any],
                let string = body["url"] as? String
            else { return nil }
            
            return URL(string: string)
        }()
    }
}
