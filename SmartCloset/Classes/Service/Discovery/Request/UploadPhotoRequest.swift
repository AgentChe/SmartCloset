//
//  UploadPhotoRequest.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import Alamofire

struct UploadPhotoRequest: APIFormDataRequestBody {
    enum Object {
        case avatar
        case item
    }
    
    let image: UIImage
    let object: Object
    
    var url: String {
        GlobalDefinitions.domain + "/backend/v1/upload/"
    }
    
    var headers: HTTPHeaders? {
        [
            "Access-Token": GlobalDefinitions.apiKey
        ]
    }
    
    var parameters: [String : Data]? {
        switch object {
        case .avatar:
            guard let data = "avatar".data(using: .utf8) else { return nil }
            return ["type": data]
        case .item:
            return nil
        }
    }
}
