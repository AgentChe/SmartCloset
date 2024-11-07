//
//  RestAPITransport.swift
//  Soccer
//
//  Created by Андрей Чернышев on 11.03.2022.
//

import RxSwift
import Alamofire

final class RestAPITransport {
    func callServerApi(requestBody: APIRequestBody) -> Single<Any> {
        Single.create { single in
            let manager = Alamofire.Session.default
            manager.session.configuration.timeoutIntervalForRequest = 30
            
            let encodedUrl = requestBody.url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            let request = manager.request(encodedUrl,
                                          method: requestBody.method,
                                          parameters: requestBody.parameters,
                                          encoding: requestBody.encoding,
                                          headers: requestBody.headers)
                .validate(statusCode: [200, 201])
                .response { response in
                    if let error = response.error {
                        single(.failure(NetworkError(.serverNotAvailable, underlyingError: error)))
                    } else if let data = response.data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            single(.success(json))
                        } catch let error {
                            single(.failure(NetworkError(.serverNotAvailable, underlyingError: error)))
                        }
                    } else {
                        single(.failure(NetworkError(.serverNotAvailable)))
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func callServerApi(formDataBody: APIFormDataRequestBody) -> Single<Any> {
        Single<Any>.create { single in
            guard let url = URL(string: formDataBody.url) else {
                single(.failure(ContentError(.notContent)))
                return Disposables.create()
            }
            
            let jpeg = formDataBody.image.jpegData(compressionQuality: 0.5)
            
            let request = AF.upload(multipartFormData: { multipartFormData in
                formDataBody.parameters?.forEach { key, value in
                    multipartFormData.append(value, withName: key)
                }
                if let jpeg {
                    multipartFormData.append(jpeg, withName: "image", fileName: "\(UUID().uuidString).jpeg", mimeType: "image/jpeg")
                }
            }, to: url, headers: formDataBody.headers)
            
            request
                .response { response in
                    if let error = response.error {
                        single(.failure(NetworkError(.serverNotAvailable, underlyingError: error)))
                    } else if let data = response.data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            single(.success(json))
                        } catch let error {
                            single(.failure(NetworkError(.serverNotAvailable, underlyingError: error)))
                        }
                    } else {
                        single(.failure(NetworkError(.serverNotAvailable)))
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
