//
//  APIFormDataRequestBody.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

import Alamofire

protocol APIFormDataRequestBody {
    var url: String { get }
    var parameters: [String: Data]? { get }
    var headers: HTTPHeaders? { get }
    var image: UIImage { get }
}
