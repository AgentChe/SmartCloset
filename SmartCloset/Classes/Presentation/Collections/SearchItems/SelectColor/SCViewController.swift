//
//  SCViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 03.02.2025.
//

import UIKit
import RxSwift

final class SCViewController: UIViewController {
    typealias Result = (Color) -> Void
    
    private lazy var mainView = SCView()
    
    private let viewModel: SCViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var closeButton = UIButton()
    
    private let selected: Result
    
    private init(color: Color?, selected: @escaping Result) {
        self.selected = selected
        self.viewModel = SCViewModel(color: color)
        
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
        
        let output = viewModel.configure(input: SCViewModel.Input(
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
extension SCViewController {
    static func make(color: Color?, selected: @escaping Result) -> SCViewController {
        let vc = SCViewController(color: color, selected: selected)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "SelectColor.Title".localized
        return vc
    }
}

// MARK: Private
private extension SCViewController {
    func route(_ route: SCViewModel.Route) {
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
        closeButton.setImage(UIImage(named: "SelectColor.Close"), for: .normal)
        
        let item = UIBarButtonItem(customView: closeButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 24.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 24.scale).isActive = true
        
        navigationItem.rightBarButtonItem = item
    }
}
