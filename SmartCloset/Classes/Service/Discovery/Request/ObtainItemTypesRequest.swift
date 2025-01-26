//
//  ObtainItemTypesRequest.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 26.01.2025.
//

import Alamofire

struct ObtainItemTypesRequest: APIRequestBody {
    var url: String {
        GlobalDefinitions.domain + "/backend/v1/discovery/itemtypes"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: HTTPHeaders? {
        [
            "Access-Token": GlobalDefinitions.apiKey
        ]
    }
}
