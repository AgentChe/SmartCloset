//
//  UploadPhotoRequest.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import Alamofire

struct UploadPhotoRequest: APIFormDataRequestBody {
    let image: UIImage
    
    var url: String {
        GlobalDefinitions.domain + "/backend/v1/upload/"
    }
    
    var headers: HTTPHeaders? {
        [
            "Access-Token": GlobalDefinitions.apiKey
        ]
    }
    
    var parameters: [String : Data]? {
        nil
    }
}
