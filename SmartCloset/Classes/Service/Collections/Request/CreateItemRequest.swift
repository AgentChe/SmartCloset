//
//  CreateItemRequest.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 31.01.2025.
//

import Alamofire

struct CreateItemRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let name: String
    let image: String
    let category: String
    let itemType: String
    let colorName: String
    let colorCode: String
    let material: String
    let comments: String?
    
    var url: String {
        GlobalDefinitions.domain + "/backend/v1/collections/item/create"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var headers: HTTPHeaders? {
        [
            "Access-Token": GlobalDefinitions.apiKey
        ]
    }
    
    var parameters: Parameters? {
        [
            "anonymous_id": anonymousId,
            "internal_id": internalId,
            "name": name,
            "image": image,
            "category": category,
            "type": itemType,
            "color": [
                colorName: colorCode
            ],
            "material": material,
            "comments": comments ?? NSNull()
        ]
    }
}
