//
//  EditItemRequest.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 31.01.2025.
//

import Alamofire

struct EditItemRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let id: String
    let name: String
    let image: String?
    let category: String?
    let itemType: String?
    let colorName: String?
    let colorCode: String?
    let material: String?
    let comments: String?
    
    var url: String {
        GlobalDefinitions.domain + "/backend/v1/collections/item/\(id)"
    }
    
    var method: HTTPMethod {
        .put
    }
    
    var headers: HTTPHeaders? {
        [
            "Access-Token": GlobalDefinitions.apiKey
        ]
    }
    
    var parameters: Parameters? {
        let color: [String: String]? = {
            guard let colorName, let colorCode else { return nil }
            return [colorName: colorCode]
        }()
        
        return [
            "anonymous_id": anonymousId,
            "internal_id": internalId,
            "name": name,
            "image": image ?? NSNull(),
            "category": category ?? NSNull(),
            "type": itemType ?? NSNull(),
            "color": color ?? NSNull(),
            "material": material ?? NSNull(),
            "comments": comments ?? NSNull()
        ]
    }
}
