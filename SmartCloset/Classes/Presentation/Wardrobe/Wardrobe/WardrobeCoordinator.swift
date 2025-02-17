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
    
    lazy var itemsVC = WardrobeItemsViewController()
    lazy var looksVC = WardrobeLooksViewController()
    lazy var collectionsVC = WardrobeCollectionsViewController(openCollection: openCollection, createCollection: createCollection)
    
    private var previousVC: UIViewController?
    
    private let openCollection: (Collection) -> Void
    private let createCollection: () -> Void
    
    init(
        parentVC: UIViewController?,
        container: UIView,
        openCollection: @escaping (Collection) -> Void,
        createCollection: @escaping () -> Void
    ) {
        self.parentVC = parentVC
        self.container = container
        self.openCollection = openCollection
        self.createCollection = createCollection
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
