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
                let vc = GenerateLookViewController.make(lookItems: lookItems, complete: { [weak nc] look in
                    let vc = CLRViewController.make(look: look, close: {
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
            
            nc?.setViewControllers([vc], animated: true)
        }, close: { [weak nc] in
            nc?.dismiss(animated: true)
        })
        
        nc.setViewControllers([vc], animated: false)
        nc.modalPresentationStyle = .fullScreen
        
        from.present(nc, animated: true)
    }
    
    func create(from: UIViewController) {
        let nc = NavigationController()
        
        let vc = CreateLookViewController.make(inputData: nil, generateWithItems: { [weak nc] lookItems in
            let vc = GenerateLookViewController.make(lookItems: lookItems, complete: { [weak nc] look in
                let vc = CLRViewController.make(look: look, close: {
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
