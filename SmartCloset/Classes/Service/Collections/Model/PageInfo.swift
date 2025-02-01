//
//  Page.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 30.01.2025.
//

struct PageInfo {
    let current: Int
    let nextPage: Int
    let total: Int
}

// MARK: Public
extension PageInfo {
    init?(json: [String: Any]) {
        guard
            let current = json["current"] as? Int,
            let nextPage = json["next"] as? Int,
            let total = json["total"] as? Int
        else {
            return nil
        }
        
        self.current = current
        self.nextPage = nextPage
        self.total = total
    }
}
