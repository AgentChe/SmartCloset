//
//  CreateCollectionAssembly.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 09.02.2025.
//

import UIKit

final class CreateCollectionAssembly {
    func create(from: UIViewController) {
        let nc = NavigationController()
        
        let vc = CCSelectLooksViewController.make(selectedLooksIds: [], close: { [weak nc] in
            nc?.dismiss(animated: true)
        }, result: { [weak nc] looks in
            let vc = CreateCollectionViewController.make(looks: looks, close: { [weak nc] in
                nc?.dismiss(animated: true)
            })
            nc?.pushViewController(vc, animated: true)
        })
        
        nc.setViewControllers([vc], animated: false)
        nc.modalPresentationStyle = .fullScreen
        
        from.present(nc, animated: true)
    }
}
