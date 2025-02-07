//
//  CreateLookRequest.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 31.01.2025.
//

import Alamofire

struct CreateLookRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let topItemId: String?
    let bottomItemId: String?
    let shoesItemId: String?
    let bagsItemId: String?
    let accessoriesItemId: String?
    
    var url: String {
        GlobalDefinitions.domain + "/backend/v1/collections/look/create"
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
            "item_top_id": topItemId ?? NSNull(),
            "item_bottom_id": bottomItemId ?? NSNull(),
            "item_shoes_id": shoesItemId ?? NSNull(),
            "item_bags_id": bagsItemId ?? NSNull(),
            "item_accessories_id": accessoriesItemId ?? NSNull()
        ]
    }
}
