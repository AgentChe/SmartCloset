//
//  SearchItemsViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 01.02.2025.
//

import UIKit
import RxSwift

final class SearchItemsViewController: UIViewController {
    private lazy var mainView = SearchItemsView()
    
    private lazy var viewModel = SearchItemsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: SearchItemsViewModel.Input(
            didTapFilter: mainView.filterButton.rx.tap.asSignal()
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension SearchItemsViewController {
    static func make() -> SearchItemsViewController {
        let vc = SearchItemsViewController()
        vc.navigationItem.title = "SearchItems.Title".localized
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension SearchItemsViewController {
    func route(_ route: SearchItemsViewModel.Route) {
        switch route {
        case .filter:
            let vc = SIFilterViewController.make(category: nil, type: nil, color: nil, material: nil)
            present(vc, animated: true)
        }
    }
}
