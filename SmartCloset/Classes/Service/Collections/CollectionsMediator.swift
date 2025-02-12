//
//  CollectionsMediator.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 31.01.2025.
//

import RxSwift
import RxCocoa

final class CollectionsMediator {
    static let shared = CollectionsMediator()
    
    private lazy var itemCreatedTrigger = PublishRelay<Item>()
    private lazy var itemEditedTrigger = PublishRelay<Item>()
    private lazy var itemDeletedTrigger = PublishRelay<String>()
    private lazy var itemAddFavoriteTrigger = PublishRelay<String>()
    private lazy var itemRemoveFromFavoriteTrigger = PublishRelay<String>()
    private lazy var lookCreatedTrigger = PublishRelay<Look>()
    private lazy var lookEditedTrigger = PublishRelay<Look>()
    private lazy var lookDeletedTrigger = PublishRelay<String>()
    private lazy var lookAddFavoriteTrigger = PublishRelay<String>()
    private lazy var lookRemoveFromFavoriteTrigger = PublishRelay<String>()
    private lazy var collectionCreatedTrigger = PublishRelay<Collection>()
    private lazy var collectionEditedTrigger = PublishRelay<Collection>()
    private lazy var collectionDeletedTrigger = PublishRelay<String>()
    private lazy var collectionAddFavoriteTrigger = PublishRelay<String>()
    private lazy var collectionRemoveFromFavoriteTrigger = PublishRelay<String>()
    
    private init() {}
}

// MARK: Publc
extension CollectionsMediator {
    func itemCreatedNotify(item: Item) {
        itemCreatedTrigger.accept(item)
    }
    
    func itemEditedNotify(item: Item) {
        itemEditedTrigger.accept(item)
    }
    
    func itemDeletedNotify(id: String) {
        itemDeletedTrigger.accept(id)
    }
    
    func itemAddFavoriteNotify(id: String) {
        itemAddFavoriteTrigger.accept(id)
    }
    
    func itemRemoveFromFavoriteNotify(id: String) {
        itemRemoveFromFavoriteTrigger.accept(id)
    }
    
    func lookCreatedNotify(look: Look) {
        lookCreatedTrigger.accept(look)
    }
    
    func lookEditedNotify(look: Look) {
        lookEditedTrigger.accept(look)
    }
    
    func lookDeletedNotify(id: String) {
        lookDeletedTrigger.accept(id)
    }
    
    func lookAddFavoriteNotify(id: String) {
        lookAddFavoriteTrigger.accept(id)
    }
    
    func lookRemoveFromFavoriteNotify(id: String) {
        lookRemoveFromFavoriteTrigger.accept(id)
    }
    
    func collectionCreatedNotify(collection: Collection) {
        collectionCreatedTrigger.accept(collection)
    }
    
    func collectionEditedNotify(collection: Collection) {
        collectionEditedTrigger.accept(collection)
    }
    
    func collectionDeletedNotify(id: String) {
        collectionDeletedTrigger.accept(id)
    }
    
    func collectionAddFavoriteNotify(id: String) {
        collectionAddFavoriteTrigger.accept(id)
    }
    
    func collectionRemoveFromFavoriteNotify(id: String) {
        collectionRemoveFromFavoriteTrigger.accept(id)
    }
    
    var itemCreated: Signal<Item> {
        itemCreatedTrigger.asSignal()
    }
    
    var itemEdited: Signal<Item> {
        itemEditedTrigger.asSignal()
    }
    
    var itemDeleted: Signal<String> {
        itemDeletedTrigger.asSignal()
    }
    
    var itemAddFavorite: Signal<String> {
        itemAddFavoriteTrigger.asSignal()
    }
    
    var itemRemoveFromFavorite: Signal<String> {
        itemRemoveFromFavoriteTrigger.asSignal()
    }
    
    var lookCreated: Signal<Look> {
        lookCreatedTrigger.asSignal()
    }
    
    var lookEdited: Signal<Look> {
        lookEditedTrigger.asSignal()
    }
    
    var lookDeleted: Signal<String> {
        lookDeletedTrigger.asSignal()
    }
    
    var lookAddFavorite: Signal<String> {
        lookAddFavoriteTrigger.asSignal()
    }
    
    var lookRemoveFromFavorite: Signal<String> {
        lookRemoveFromFavoriteTrigger.asSignal()
    }
    
    var collectionCreated: Signal<Collection> {
        collectionCreatedTrigger.asSignal()
    }
    
    var collectionEdited: Signal<Collection> {
        collectionEditedTrigger.asSignal()
    }
    
    var collectionDeleted: Signal<String> {
        collectionDeletedTrigger.asSignal()
    }
    
    var collectionAddFavorite: Signal<String> {
        collectionAddFavoriteTrigger.asSignal()
    }
    
    var collectionRemoveFromFavorite: Signal<String> {
        collectionRemoveFromFavoriteTrigger.asSignal()
    }
}
