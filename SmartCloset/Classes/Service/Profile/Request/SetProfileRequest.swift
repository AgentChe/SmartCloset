//
//  SetProfileRequest.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 25.01.2025.
//

import Alamofire

struct SetProfileRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let name: String?
    let avatar: String?
    let size: String?
    let gender: String?
    let heightValue: Double? // TODO: проверить
    let heightUnit: String?
    let interestedColors: [String]?
    let occasions: [String]?
    let seasons: [String]?
    
    var url: String {
        GlobalDefinitions.domain + "/backend/v1/profile/update"
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
        let attrs: [String: Any] = [
            "name": name ?? NSNull(),
            "avatar": avatar ?? NSNull(),
            "size": size ?? NSNull(),
            "sex": gender ?? NSNull(),
            "interested_color": interestedColors ?? NSNull(),
            "height": heightValue ?? NSNull(),
            "height_unit": heightUnit ?? NSNull(),
            "occasion": occasions ?? NSNull(),
            "seasons": seasons ?? NSNull()
        ]
        
        return [
            "anonymous_id": anonymousId,
            "internal_id": internalId,
            "attrs": attrs
        ]
    }
}
