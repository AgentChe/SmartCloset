//
//  CollectionsManager.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 31.01.2025.
//

import RxSwift
import RxCocoa

protocol CollectionsManagerProtocol {
    func obtainRecommendations(page: Int, limit: Int) -> Single<Page<Recommendations>?>
    func obtainItems(
        category: String?,
        attachment: GetCollectionsRequest.Attachment,
        terms: [String]?,
        page: Int,
        favorite: Bool
    ) -> Single<Page<[Item]>?>
    func createItem(
        name: String,
        image: URL,
        category: String,
        itemType: String,
        color: Color,
        material: String,
        comments: String?
    ) -> Single<RequestResult>
    func editItem(
        id: String,
        name: String,
        image: URL?,
        category: String?,
        itemType: String?,
        color: Color?,
        material: String?,
        comments: String?
    ) -> Single<RequestResult>
    func deleteItem(id: String) -> Single<RequestResult>
    func obtainLooks(
        attachment: GetCollectionsRequest.Attachment,
        terms: [String]?,
        page: Int,
        favorite: Bool
    ) -> Single<Page<[Look]>?>
    func createLook(
        topItemId: String?,
        bottomItemId: String?,
        shoesItemId: String?,
        bagsItemId: String?,
        accessoriesItemId: String?
    ) -> Single<Look?>
    func editLook(
        id: String,
        topItemId: String?,
        bottomItemId: String?,
        shoesItemId: String?,
        bagsItemId: String?,
        accessoriesItemId: String?
    ) -> Single<Look?>
    func deleteLook(id: String) -> Single<RequestResult>
    func obtainCollections(
        attachment: GetCollectionsRequest.Attachment,
        terms: [String]?,
        page: Int,
        favorite: Bool
    ) -> Single<Page<[Collection]>?>
    func createCollection(
        name: String,
        looks: [String]
    ) -> Single<Collection?>
    func editCollection(
        id: String,
        name: String,
        looks: [String]
    ) -> Single<Collection?>
    func deleteCollection(id: String) -> Single<RequestResult>
    func addFavorite(
        id: String,
        tab: AddFavoriteRequest.Tab
    ) -> Single<RequestResult>
    func removeFavorite(
        id: String,
        tab: RemoveFavoriteRequest.Tab
    ) -> Single<RequestResult>
}

final class CollectionsManager {
    private lazy var sessionManager = SessionManager()
    
    private lazy var restApiTransport = RestAPITransport()
}

// MARK: CollectionsManagerProtocol
extension CollectionsManager: CollectionsManagerProtocol {
    func obtainRecommendations(page: Int, limit: Int) -> Single<Page<Recommendations>?> {
        let request = GetRecommendationsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            page: page,
            limit: limit
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { Recommendations.map(response: $0) }
    }
    
    func obtainItems(
        category: String? = nil,
        attachment: GetCollectionsRequest.Attachment = .all,
        terms: [String]? = nil,
        page: Int,
        favorite: Bool
    ) -> Single<Page<[Item]>?> {
        let request = GetCollectionsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            tab: .items,
            category: category,
            attachment: attachment,
            terms: terms,
            page: page,
            favorite: favorite
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { Item.map(response: $0) }
    }
    
    func createItem(
        name: String,
        image: URL,
        category: String,
        itemType: String,
        color: Color,
        material: String,
        comments: String?
    ) -> Single<RequestResult> {
        let request = CreateItemRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            name: name,
            image: image.absoluteString,
            category: category,
            itemType: itemType,
            colorName: color.name,
            colorCode: color.code,
            material: material,
            comments: comments
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { result in
                guard result.success else { return }
                
                CollectionsMediator.shared.itemCreatedNotify()
            })
    }
    
    func editItem(
        id: String,
        name: String,
        image: URL?,
        category: String?,
        itemType: String?,
        color: Color?,
        material: String?,
        comments: String?
    ) -> Single<RequestResult> {
        let request = EditItemRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id,
            name: name,
            image: image?.absoluteString,
            category: category,
            itemType: itemType,
            colorName: color?.name,
            colorCode: color?.code,
            material: material,
            comments: comments
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { result in
                guard result.success else { return }
                
                CollectionsMediator.shared.itemEditedNotify(id: id)
            })
    }
    
    func deleteItem(id: String) -> Single<RequestResult> {
        let request = DeleteItemRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { result in
                guard result.success else { return }
                
                CollectionsMediator.shared.itemDeletedNotify(id: id)
            })
    }
    
    func obtainLooks(
        attachment: GetCollectionsRequest.Attachment,
        terms: [String]?,
        page: Int,
        favorite: Bool
    ) -> Single<Page<[Look]>?> {
        let request = GetCollectionsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            tab: .looks,
            category: nil,
            attachment: attachment,
            terms: terms,
            page: page,
            favorite: favorite
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { Look.make(response: $0) }
    }
    
    func createLook(
        topItemId: String?,
        bottomItemId: String?,
        shoesItemId: String?,
        bagsItemId: String?,
        accessoriesItemId: String?
    ) -> Single<Look?> {
        let request = CreateLookRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            topItemId: topItemId,
            bottomItemId: bottomItemId,
            shoesItemId: shoesItemId,
            bagsItemId: bagsItemId,
            accessoriesItemId: accessoriesItemId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { Look(response: $0) }
            .do(onSuccess: { look in
                guard let look else { return }
                
                CollectionsMediator.shared.lookCreatedNotify(look: look)
            })
    }
    
    func editLook(
        id: String,
        topItemId: String?,
        bottomItemId: String?,
        shoesItemId: String?,
        bagsItemId: String?,
        accessoriesItemId: String?
    ) -> Single<Look?> {
        let request = EditLookRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id,
            topItemId: topItemId,
            bottomItemId: bottomItemId,
            shoesItemId: shoesItemId,
            bagsItemId: bagsItemId,
            accessoriesItemId: accessoriesItemId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { Look(response: $0) }
            .do(onSuccess: { look in
                guard let look else { return }
                
                CollectionsMediator.shared.lookEditedNotify(look: look)
            })
    }
    
    func deleteLook(id: String) -> Single<RequestResult> {
        let request = DeleteLookRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { result in
                guard result.success else { return }
                
                CollectionsMediator.shared.lookDeletedNotify(id: id)
            })
    }
    
    func obtainCollections(
        attachment: GetCollectionsRequest.Attachment,
        terms: [String]?,
        page: Int,
        favorite: Bool
    ) -> Single<Page<[Collection]>?> {
        let request = GetCollectionsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            tab: .collections,
            category: nil,
            attachment: attachment,
            terms: terms,
            page: page,
            favorite: favorite
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { Collection.make(response: $0) }
    }
    
    func createCollection(
        name: String,
        looks: [String]
    ) -> Single<Collection?> {
        let request = CreateCollectionRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            name: name,
            looks: looks
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { Collection(response: $0) }
            .do(onSuccess: { collection in
                guard let collection else { return }
                
                CollectionsMediator.shared.collectionCreatedNotify(collection: collection)
            })
    }
    
    func editCollection(
        id: String,
        name: String,
        looks: [String]
    ) -> Single<Collection?> {
        let request = EditCollectionRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id,
            name: name,
            looks: looks
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { Collection(response: $0) }
            .do(onSuccess: { collection in
                guard let collection else { return }
                
                CollectionsMediator.shared.collectionEditedNotify(collection: collection)
            })
    }
    
    func deleteCollection(id: String) -> Single<RequestResult> {
        let request = DeleteCollectionRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { result in
                guard result.success else { return }
                
                CollectionsMediator.shared.collectionDeletedNotify(id: id)
            })
    }
    
    func addFavorite(
        id: String,
        tab: AddFavoriteRequest.Tab
    ) -> Single<RequestResult> {
        let request = AddFavoriteRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id,
            tab: tab
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { result in
                guard result.success else { return }
                
                switch tab {
                case .items:
                    CollectionsMediator.shared.itemAddFavoriteNotify(id: id)
                case .looks:
                    CollectionsMediator.shared.lookAddFavoriteNotify(id: id)
                case .collections:
                    CollectionsMediator.shared.collectionAddFavoriteNotify(id: id)
                }
            })
    }
    
    func removeFavorite(
        id: String,
        tab: RemoveFavoriteRequest.Tab
    ) -> Single<RequestResult> {
        let request = RemoveFavoriteRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id,
            tab: tab
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { result in
                guard result.success else { return }
                
                switch tab {
                case .items:
                    CollectionsMediator.shared.itemRemoveFromFavoriteNotify(id: id)
                case .looks:
                    CollectionsMediator.shared.lookRemoveFromFavoriteNotify(id: id)
                case .collections:
                    CollectionsMediator.shared.collectionRemoveFromFavoriteNotify(id: id)
                }
            })
    }
}
