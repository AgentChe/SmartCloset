//
//  ObtainProfileRequest.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 25.01.2025.
//

import Alamofire

struct ObtainProfileRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    
    var url: String {
        GlobalDefinitions.domain + "/backend/v1/profile/get"
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
