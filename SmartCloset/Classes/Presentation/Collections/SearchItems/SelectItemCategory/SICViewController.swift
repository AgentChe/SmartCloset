//
//  SICViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 02.02.2025.
//

import UIKit
import RxSwift

final class SICViewController: UIViewController {
    typealias Result = (ItemCategory, ItemType) -> Void
    
    private lazy var mainView = SICView()
    
    private lazy var viewModel = SICViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var closeButton = UIButton()
    
    private let selected: Result
    
    private init(selected: @escaping Result) {
        self.selected = selected
        
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
        
        let output = viewModel.configure(input: SICViewModel.Input(
            didTapClose: closeButton.rx.tap.asSignal(),
            didSelect: mainView.tableView.didSelect
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
extension SICViewController {
    static func make(selected: @escaping Result) -> SICViewController {
        let vc = SICViewController(selected: selected)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "SelectItemCategory.Title".localized
        return vc
    }
}

// MARK: Private
private extension SICViewController {
    func route(_ route: SICViewModel.Route) {
        switch route {
        case .dismiss:
            navigationController?.dismiss(animated: true)
        case .selectItemType(let itemCategory):
            let vc = SITViewController.make(itemCategory: itemCategory, itemType: nil, selected: { [weak self] category, type in
                self?.selected(category, type)
            })
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func addCloseButton() {
        closeButton.backgroundColor = UIColor.clear
        closeButton.setImage(UIImage(named: "Close.Black"), for: .normal)
        
        let item = UIBarButtonItem(customView: closeButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 24.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 24.scale).isActive = true
        
        navigationItem.rightBarButtonItem = item
    }
}
