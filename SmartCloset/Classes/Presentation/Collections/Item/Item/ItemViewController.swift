//
//  ItemViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 04.02.2025.
//

import UIKit
import RxSwift

// TODO: Add to wardrobe
final class ItemViewController: UIViewController {
    private lazy var mainView = ItemView()
    
    private let viewModel: ItemViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private init(item: Item) {
        viewModel = ItemViewModel(item: item)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: ItemViewModel.Input())
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension ItemViewController {
    static func make(item: Item) -> ItemViewController {
        let vc = ItemViewController(item: item)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = item.name
        return vc
    }
}
