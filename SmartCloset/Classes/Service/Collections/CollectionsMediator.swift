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
    
    private lazy var itemCreatedTrigger = PublishRelay<Void>()
    private lazy var itemEditedTrigger = PublishRelay<String>()
    private lazy var itemDeletedTrigger = PublishRelay<String>()
    private lazy var itemAddFavoriteTrigger = PublishRelay<String>()
    private lazy var itemRemoveFromFavoriteTrigger = PublishRelay<String>()
    private lazy var lookCreatedTrigger = PublishRelay<Void>()
    private lazy var lookEditedTrigger = PublishRelay<String>()
    private lazy var lookDeletedTrigger = PublishRelay<String>()
    private lazy var lookAddFavoriteTrigger = PublishRelay<String>()
    private lazy var lookRemoveFromFavoriteTrigger = PublishRelay<String>()
    private lazy var collectionCreatedTrigger = PublishRelay<Void>()
    private lazy var collectionEditedTrigger = PublishRelay<String>()
    private lazy var collectionDeletedTrigger = PublishRelay<String>()
    private lazy var collectionAddFavoriteTrigger = PublishRelay<String>()
    private lazy var collectionRemoveFromFavoriteTrigger = PublishRelay<String>()
    
    private init() {}
}

// MARK: Publc
extension CollectionsMediator {
    func itemCreatedNotify() {
        itemCreatedTrigger.accept(Void())
    }
    
    func itemEditedNotify(id: String) {
        itemEditedTrigger.accept(id)
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
    
    func lookCreatedNotify() {
        lookCreatedTrigger.accept(Void())
    }
    
    func lookEditedNotify(id: String) {
        lookEditedTrigger.accept(id)
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
    
    func collectionCreatedNotify() {
        collectionCreatedTrigger.accept(Void())
    }
    
    func collectionEditedNotify(id: String) {
        collectionEditedTrigger.accept(id)
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
    
    var itemCreated: Signal<Void> {
        itemCreatedTrigger.asSignal()
    }
    
    var itemEdited: Signal<String> {
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
    
    var lookCreated: Signal<Void> {
        itemCreatedTrigger.asSignal()
    }
    
    var lookEdited: Signal<String> {
        itemEditedTrigger.asSignal()
    }
    
    var lookDeleted: Signal<String> {
        itemDeletedTrigger.asSignal()
    }
    
    var lookAddFavorite: Signal<String> {
        lookAddFavoriteTrigger.asSignal()
    }
    
    var lookRemoveFromFavorite: Signal<String> {
        lookRemoveFromFavoriteTrigger.asSignal()
    }
    
    var collectionCreated: Signal<Void> {
        itemCreatedTrigger.asSignal()
    }
    
    var collectionEdited: Signal<String> {
        itemEditedTrigger.asSignal()
    }
    
    var collectionDeleted: Signal<String> {
        itemDeletedTrigger.asSignal()
    }
    
    var collectionAddFavorite: Signal<String> {
        lookAddFavoriteTrigger.asSignal()
    }
    
    var collectionRemoveFromFavorite: Signal<String> {
        collectionRemoveFromFavoriteTrigger.asSignal()
    }
}
