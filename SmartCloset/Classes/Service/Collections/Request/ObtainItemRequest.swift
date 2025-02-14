//
//  ObtainItemRequest.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 14.02.2025.
//

import Alamofire

struct ObtainItemRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let id: String
    
    var url: String {
        GlobalDefinitions.domain + "/backend/v1/collections/item/\(id)"
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
            "internal_id": internalId
        ]
    }
}
