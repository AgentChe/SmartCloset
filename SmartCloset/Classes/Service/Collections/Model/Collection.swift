//
//  Collection.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 30.01.2025.
//

struct Collection {
    let id: String
    let name: String
    let looks: [Look]
}

// MARK: Publics
extension Collection {
    static func make(response: Any) -> Page<[Collection]>? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let pageInfo: PageInfo = {
                guard let pagination = body["pagination"] as? [String: Any] else { return nil }
                return PageInfo(json: pagination)
            }(),
            let array = body["collections"] as? [[String: Any]]
        else { return nil }
        
        let collections = array.compactMap { Collection(json: $0) }
        
        return Page(info: pageInfo, elements: collections)
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String,
            let array = json["looks_filled"] as? [[String: Any]]
        else { return nil }
        
        self.id = id
        self.name = name
        self.looks = array.compactMap { Look(json: $0) }
    }
}
