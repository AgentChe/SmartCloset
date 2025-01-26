//
//  ObtainCategoriesRequest.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 26.01.2025.
//

import Alamofire

struct ObtainCategoriesRequest: APIRequestBody {
    var url: String {
        GlobalDefinitions.domain + "/backend/v1/discovery/categories"
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
