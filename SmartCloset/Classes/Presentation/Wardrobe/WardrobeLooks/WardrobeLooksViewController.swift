//
//  WardrobeLooksViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 16.02.2025.
//

import UIKit
import RxSwift

final class WardrobeLooksViewController: UIViewController {
    private lazy var mainView = WardrobeLooksView()
    
    private lazy var viewModel = WardrobeLooksViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: WardrobeLooksViewModel.Input())
    }
}

// MARK: Public
extension WardrobeLooksViewController {
    static func make() -> WardrobeLooksViewController {
        WardrobeLooksViewController()
    }
}

// MARK: Private
private extension WardrobeLooksViewController {
    
}
