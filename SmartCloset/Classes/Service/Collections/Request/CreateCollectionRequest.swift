//
//  CreateCollectionRequest.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 31.01.2025.
//

import Alamofire

struct CreateCollectionRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let name: String
    let looks: [String]
    
    var url: String {
        GlobalDefinitions.domain + "/backend/v1/collections/collection/create"
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
            "looks": looks
        ]
    }
}
