//
//  GetRecommendationsRequest.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 05.02.2025.
//

import Alamofire

struct GetRecommendationsRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let page: Int
    let limit: Int
    
    var url: String {
        GlobalDefinitions.domain + "/backend/v1/collections/recommendations"
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
            "page": page,
            "limit": 20
        ]
    }
}
