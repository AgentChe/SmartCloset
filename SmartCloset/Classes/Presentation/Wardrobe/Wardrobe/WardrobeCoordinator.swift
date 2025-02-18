//
//  WardrobeCoordinator.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 16.02.2025.
//

import UIKit

final class WardrobeCoordinator {
    weak var parentVC: UIViewController?
    weak var container: UIView?
    
    lazy var itemsVC = WardrobeItemsViewController.make(
        openItem: openItem,
        createItem: createItem,
        isEmpty: itemsContentEmpty
    )
    lazy var looksVC = WardrobeLooksViewController.make(
        openLook: openLook,
        openFavoritesList: openFavoritesLooks,
        openAllList: openAllLooks,
        createLook: createLook,
        isEmpty: looksContentEmpty
    )
    lazy var collectionsVC = WardrobeCollectionsViewController.make(
        openCollection: openCollection,
        createCollection: createCollection,
        isEmpty: collectionsContentEmpty
    )
    
    private var previousVC: UIViewController?
    
    private let openCollection: (Collection) -> Void
    private let createCollection: () -> Void
    private let collectionsContentEmpty: (Bool) -> Void
    private let openLook: (Look) -> Void
    private let openFavoritesLooks: () -> Void
    private let openAllLooks: () -> Void
    private let createLook: () -> Void
    private let looksContentEmpty: (Bool) -> Void
    private let openItem: (Item) -> Void
    private let createItem: () -> Void
    private let itemsContentEmpty: (Bool) -> Void
    
    init(
        parentVC: UIViewController?,
        container: UIView,
        openCollection: @escaping (Collection) -> Void,
        createCollection: @escaping () -> Void,
        collectionsContentEmpty: @escaping (Bool) -> Void,
        openLook: @escaping (Look) -> Void,
        openFavoritesLooks: @escaping () -> Void,
        openAllLooks: @escaping () -> Void,
        createLook: @escaping () -> Void,
        looksContentEmpty: @escaping (Bool) -> Void,
        openItem: @escaping (Item) -> Void,
        createItem: @escaping () -> Void,
        itemsContentEmpty: @escaping (Bool) -> Void
    ) {
        self.parentVC = parentVC
        self.container = container
        self.openCollection = openCollection
        self.createCollection = createCollection
        self.collectionsContentEmpty = collectionsContentEmpty
        self.openLook = openLook
        self.openFavoritesLooks = openFavoritesLooks
        self.openAllLooks = openAllLooks
        self.createLook = createLook
        self.looksContentEmpty = looksContentEmpty
        self.openItem = openItem
        self.createItem = createItem
        self.itemsContentEmpty = itemsContentEmpty
    }
    
    func change(tab: WardrobeTabItemButton.Tab) {
        switch tab {
        case .items:
            changeVC(on: itemsVC)
        case .looks:
            changeVC(on: looksVC)
        case .collections:
            changeVC(on: collectionsVC)
        }
    }
}

// MARK: Private
private extension WardrobeCoordinator {
    func changeVC(on vc: UIViewController) {
        if let previousVC = self.previousVC {
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
        }
    
        self.previousVC = vc
        
        guard let parentVC, let container else {
            return
        }
    
        parentVC.addChild(vc)
        vc.view.frame = container.bounds
        container.addSubview(vc.view)
        vc.willMove(toParent: parentVC)
    }
}
