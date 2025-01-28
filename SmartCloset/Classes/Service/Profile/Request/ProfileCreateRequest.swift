//
//  ProfileCreateRequest.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 06.09.2024.
//

import Alamofire

struct ProfileCreateRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    
    var url: String {
        GlobalDefinitions.domain + "/backend/v1/profile/create"
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
