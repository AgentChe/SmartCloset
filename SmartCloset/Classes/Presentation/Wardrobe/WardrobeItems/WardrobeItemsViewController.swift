//
//  WardrobeItemsViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 16.02.2025.
//

import UIKit
import RxSwift

final class WardrobeItemsViewController: UIViewController {
    private lazy var mainView = WardrobeItemsView()
    
    private lazy var viewModel = WardrobeItemsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: WardrobeItemsViewModel.Input())
    }
}

// MARK: Public
extension WardrobeItemsViewController {
    static func make() -> WardrobeItemsViewController {
        WardrobeItemsViewController()
    }
}

// MARK: Private
private extension WardrobeItemsViewController {
    
}
