//
//  EditCollectionRequest.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 31.01.2025.
//

import Alamofire

struct EditCollectionRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let id: String
    let name: String
    let looks: [String]
    
    var url: String {
        GlobalDefinitions.domain + "/backend/v1/collections/collection/\(id)"
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
        [
            "anonymous_id": anonymousId,
            "internal_id": internalId,
            "name": name,
            "looks": looks
        ]
    }
}
