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
    let heightValue: Double?
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
        [
            "anonymous_id": anonymousId,
            "internal_id": internalId,
            "attrs": [
                "name": name as Any,
                "avatar": avatar as Any,
                "size": size as Any,
                "sex": gender as Any,
                "interested_color": interestedColors as Any,
                "height": heightValue as Any,
                "height_unit": heightUnit as Any,
                "occasion": occasions as Any,
                "seasons": seasons as Any
            ]
        ]
    }
}
