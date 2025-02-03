//
//  SearchItemsViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 01.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchItemsViewController: UIViewController {
    private lazy var mainView = SearchItemsView()
    
    private lazy var viewModel = SearchItemsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var appliedFilterTrigger = PublishRelay<SIFilterViewController.Data>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: SearchItemsViewModel.Input(
            didTapFilter: mainView.filterButton.rx.tap.asSignal(),
            appliedFilter: appliedFilterTrigger.asSignal()
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.selectedFilterItemsCount
            .drive(Binder(mainView.filterButton) { base, count in
                base.setup(count: count)
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
        case .openFilter(let data):
            let vc = SIFilterViewController.make(
                category: data.category,
                type: data.type,
                color: data.color,
                material: data.material
            ) { [weak self] data in
                self?.appliedFilterTrigger.accept(data)
            }
            present(vc, animated: true)
        }
    }
}
