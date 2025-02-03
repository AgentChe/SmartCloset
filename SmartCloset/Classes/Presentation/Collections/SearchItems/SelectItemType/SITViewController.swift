//
//  SITViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 02.02.2025.
//

import UIKit
import RxSwift

final class SITViewController: UIViewController {
    typealias Result = (ItemCategory, ItemType) -> Void
    
    private lazy var mainView = SITView()
    
    private let viewModel: SITViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var closeButton = UIButton()
    
    private let selected: Result
    
    private init(itemCategory: ItemCategory, itemType: ItemType?, selected: @escaping Result) {
        self.selected = selected
        self.viewModel = SITViewModel(itemCategory: itemCategory, itemType: itemType)
        
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
        
        let output = viewModel.configure(input: SITViewModel.Input(
            didTapClose: closeButton.rx.tap.asSignal(),
            didTapSave: mainView.saveButton.rx.tap.asSignal()
        ))
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        addCloseButton()
    }
}

// MARK: Public
extension SITViewController {
    static func make(itemCategory: ItemCategory, itemType: ItemType?, selected: @escaping Result) -> SITViewController {
        let vc = SITViewController(itemCategory: itemCategory, itemType: itemType, selected: selected)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = {
            let category = ItemCategory.DefaultLocalized().name(category: itemCategory)
            return String(format: "SelectItemType.Title".localized, category)
        }()
        return vc
    }
}

// MARK: Private
private extension SITViewController {
    func route(_ route: SITViewModel.Route) {
        switch route {
        case .dismiss:
            navigationController?.dismiss(animated: true)
        case .complete(let itemCategory, let itemType):
            navigationController?.dismiss(animated: true) { [weak self] in
                self?.selected(itemCategory, itemType)
            }
        }
    }
    
    func addCloseButton() {
        closeButton.backgroundColor = UIColor.clear
        closeButton.setImage(UIImage(named: "SelectItemType.Close"), for: .normal)
        
        let item = UIBarButtonItem(customView: closeButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 24.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 24.scale).isActive = true
        
        navigationItem.rightBarButtonItem = item
    }
}
