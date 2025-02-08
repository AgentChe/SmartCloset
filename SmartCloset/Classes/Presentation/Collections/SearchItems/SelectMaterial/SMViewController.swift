//
//  SMViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 02.02.2025.
//

import UIKit
import RxSwift

final class SMViewController: UIViewController {
    typealias Result = (Material) -> Void
    
    private lazy var mainView = SMView()
    
    private let viewModel: SMViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var closeButton = UIButton()
    
    private let selected: Result
    
    private init(material: Material?, selected: @escaping Result) {
        self.selected = selected
        self.viewModel = SMViewModel(material: material)
        
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
        
        let output = viewModel.configure(input: SMViewModel.Input(
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
extension SMViewController {
    static func make(material: Material?, selected: @escaping Result) -> SMViewController {
        let vc = SMViewController(material: material, selected: selected)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "SelectMaterial.Title".localized
        return vc
    }
}

// MARK: Private
private extension SMViewController {
    func route(_ route: SMViewModel.Route) {
        switch route {
        case .dismiss:
            navigationController?.dismiss(animated: true)
        case .complete(let material):
            navigationController?.dismiss(animated: true) { [weak self] in
                self?.selected(material)
            }
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
