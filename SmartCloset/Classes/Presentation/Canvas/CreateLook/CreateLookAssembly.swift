//
//  CreateLookAssembly.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 06.02.2025.
//

import UIKit

final class CreateLookAssembly {
    func create(from: UIViewController, itemCategory: ItemCategory) {
        let nc = NavigationController()
        
        let vc = SIFCLViewController.make(itemCategory: itemCategory, result: { [weak nc] itemCategory, item in
            let vc = CreateLookViewController.make(inputData: (itemCategory, item), generateWithItems: { [weak nc] lookItems in
                let vc = GenerateLookViewController.make(lookItems: lookItems, complete: { lookItems in
                    print("___ \(lookItems)")
                }, close: { [weak nc] in
                    nc?.dismiss(animated: true)
                })
                
                nc?.setViewControllers([vc], animated: true)
            }, close: { [weak nc] in
                nc?.dismiss(animated: true)
            })
            
            nc?.setViewControllers([vc], animated: true)
        }, close: { [weak nc] in
            nc?.dismiss(animated: true)
        })
        
        nc.setViewControllers([vc], animated: false)
        nc.modalPresentationStyle = .fullScreen
        
        from.present(nc, animated: true)
    }
}
