//
//  DiscoveryManager.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 26.01.2025.
//

import RxSwift

protocol DiscoveryManagerProtocol {
    func obtainColors(forceUpdate: Bool) -> Single<[Color]?>
    func upload(image: UIImage, object: UploadPhotoRequest.Object) -> Single<Image>
}

final class DiscoveryManager {
    private lazy var restApiTransport = RestAPITransport()
}

// MARK: Public
extension DiscoveryManager: DiscoveryManagerProtocol {
    func obtainColors(forceUpdate: Bool) -> Single<[Color]?> {
        forceUpdate ? loadColors() : cachedColors()
    }
    
    func upload(image: UIImage, object: UploadPhotoRequest.Object) -> Single<Image> {
        let request = UploadPhotoRequest(image: image, object: object)
        
        return restApiTransport
            .callServerApi(formDataBody: request)
            .map { Image(response: $0) }
    }
}

// MARK: Private
private extension DiscoveryManager {
    enum Constants {
        static let colorsKey = "dm_colors"
    }
    
    func loadColors() -> Single<[Color]?> {
        restApiTransport
            .callServerApi(requestBody: ObtainColorsRequest())
            .map { Color.make(response: $0) }
            .do(onSuccess: { colors in
                guard let colors, let data = try? JSONEncoder().encode(colors) else { return }
                
                UserDefaults.standard.set(data, forKey: Constants.colorsKey)
            })
    }
    
    func cachedColors() -> Single<[Color]?> {
        Single<[Color]?>.create { single in
            let colors: [Color]? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.colorsKey) else { return nil }
                return try? JSONDecoder().decode([Color].self, from: data)
            }()
            
            single(.success(colors))
            
            return Disposables.create()
        }
    }
}
