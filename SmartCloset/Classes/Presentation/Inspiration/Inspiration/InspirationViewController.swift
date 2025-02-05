//
//  InspirationViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import UIKit
import RxSwift

final class InspirationViewController: UIViewController {
    private lazy var mainView = InspirationView()
    
    private lazy var viewModel = InspirationViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: InspirationViewModel.Input(
            didTapSettings: mainView.headerView.settingsButton.rx.tap.asSignal(),
            didTapSearch: mainView.headerView.searchButton.rx.tap.asSignal(),
            didSelectItemCategory: mainView.tableView.didSelectItemCategory,
            didSelectItem: mainView.tableView.didSelectItem,
            didSelectLook: mainView.tableView.didSelectLook,
            didTapSeeAllRecommendations: mainView.tableView.didTapSeeAllRecommendations
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.headerData
            .drive(Binder(mainView.headerView) { base, data in
                base.setup(data: data)
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension InspirationViewController {
    static func make() -> InspirationViewController {
        let vc = InspirationViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension InspirationViewController {
    func route(_ route: InspirationViewModel.Route) {
        switch route {
        case .settings:
            let vc = SettingsViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .search:
            let vc = SearchItemsViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .openItemCategory(let itemCategory):
            let vc = ItemCategoryViewController.make(itemCategory: itemCategory)
            navigationController?.pushViewController(vc, animated: true)
        case .openItem(let item):
            let vc = ItemViewController.make(item: item)
            navigationController?.pushViewController(vc, animated: true)
        case .openLook(let look):
            print("\(look.id)") // TODO
        case .openRecommendations:
            print("openRecommendations") // TODO
        }
    }
}
