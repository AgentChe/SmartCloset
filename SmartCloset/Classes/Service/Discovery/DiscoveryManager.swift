//
//  DiscoveryManager.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 26.01.2025.
//

import RxSwift

protocol DiscoveryManagerProtocol {
    func obtainColors(forceUpdate: Bool) -> Single<[Color]?>
    func obtainCategories(forceUpdate: Bool) -> Single<[Category]?>
    func obtainItemTypes(forceUpdate: Bool) -> Single<[ItemType]?>
}

final class DiscoveryManager {
    private lazy var restApiTransport = RestAPITransport()
}

// MARK: Public
extension DiscoveryManager: DiscoveryManagerProtocol {
    func obtainColors(forceUpdate: Bool) -> Single<[Color]?> {
        forceUpdate ? loadColors() : cachedColors()
    }
    
    func obtainCategories(forceUpdate: Bool) -> Single<[Category]?> {
        forceUpdate ? loadCategories() : cachedCategories()
    }
    
    func obtainItemTypes(forceUpdate: Bool) -> Single<[ItemType]?> {
        forceUpdate ? loadItemTypes() : cachedItemTypes()
    }
}

// MARK: Private
private extension DiscoveryManager {
    enum Constants {
        static let colorsKey = "dm_colors"
        static let categoriesKey = "dm_categories"
        static let itemTypesKey = "dm_itemTypes"
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
    
    func loadCategories() -> Single<[Category]?> {
        restApiTransport
            .callServerApi(requestBody: ObtainCategoriesRequest())
            .map { Category.make(response: $0) }
            .do(onSuccess: { categories in
                guard let categories, let data = try? JSONEncoder().encode(categories) else { return }
                
                UserDefaults.standard.set(data, forKey: Constants.categoriesKey)
            })
    }
    
    func cachedCategories() -> Single<[Category]?> {
        Single<[Category]?>.create { single in
            let categories: [Category]? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.categoriesKey) else { return nil }
                return try? JSONDecoder().decode([Category].self, from: data)
            }()
            
            single(.success(categories))
            
            return Disposables.create()
        }
    }
    
    func loadItemTypes() -> Single<[ItemType]?> {
        restApiTransport
            .callServerApi(requestBody: ObtainItemTypesRequest())
            .map { ItemType.make(response: $0) }
            .do(onSuccess: { itemTypes in
                guard let itemTypes, let data = try? JSONEncoder().encode(itemTypes) else { return }
                
                UserDefaults.standard.set(data, forKey: Constants.itemTypesKey)
            })
    }
    
    func cachedItemTypes() -> Single<[ItemType]?> {
        Single<[ItemType]?>.create { single in
            let itemTypes: [ItemType]? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.itemTypesKey) else { return nil }
                return try? JSONDecoder().decode([ItemType].self, from: data)
            }()
            
            single(.success(itemTypes))
            
            return Disposables.create()
        }
    }
}
