//
//  AddFavoriteRequest.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 31.01.2025.
//

import Alamofire

struct AddFavoriteRequest: APIRequestBody {
    enum Tab {
        case items, looks, collections
    }
    
    let anonymousId: String
    let internalId: String
    let id: String
    let tab: Tab
    
    var url: String {
        GlobalDefinitions.domain + "/backend/v1/favorites/"
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
            "id": id,
            "tab": tab.name
        ]
    }
}

// MARK: Additional
private extension AddFavoriteRequest.Tab {
    var name: String {
        switch self {
        case .items:
            return "items"
        case .looks:
            return "looks"
        case .collections:
            return "collections"
        }
    }
}
