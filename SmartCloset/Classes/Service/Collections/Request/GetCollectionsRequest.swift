//
//  GetCollectionsRequest.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 31.01.2025.
//

import Alamofire

struct GetCollectionsRequest: APIRequestBody {
    enum Tab {
        case items, looks, collections
    }
    
    enum Attachment {
        case all, custom, `internal`
    }
    
    let anonymousId: String
    let internalId: String
    let tab: Tab
    let category: String?
    let attachment: Attachment
    let terms: [String]?
    let page: Int
    let favorite: Bool
    
    var url: String {
        GlobalDefinitions.domain + "/backend/v1/collections/get"
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
            "limit": 20,
            "category": category ?? NSNull(),
            "tab": tab.name,
            "type": attachment.name,
            "term": terms ?? NSNull(),
            "is_favorite": favorite
        ]
    }
}

// MARK: Additional
private extension GetCollectionsRequest.Tab {
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

// MARK: Additional
private extension GetCollectionsRequest.Attachment {
    var name: String {
        switch self {
        case .all:
            return "all"
        case .custom:
            return "custom"
        case .internal:
            return "internal"
        }
    }
}
