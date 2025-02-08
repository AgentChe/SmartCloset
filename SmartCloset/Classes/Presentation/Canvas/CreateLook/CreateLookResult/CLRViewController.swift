//
//  CLRViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 08.02.2025.
//

import UIKit
import RxSwift

// TODO: Add to wardrobe
final class CLRViewController: UIViewController {
    private lazy var mainView = CLRView()
    
    private let viewModel: CLRViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var closeButton = TapAreaButton()
    
    private let close: () -> Void
    
    private init(look: Look, close: @escaping () -> Void) {
        self.viewModel = CLRViewModel(look: look)
        self.close = close
        
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
        
        addCloseButton()
        
        let output = viewModel.configure(input: CLRViewModel.Input(
            didTapClose: closeButton.rx.tap.asSignal()
        ))
        
        output.look
            .drive(Binder(mainView.itemsView) { base, look in
                base.setup(look: look)
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension CLRViewController {
    static func make(look: Look, close: @escaping () -> Void) -> CLRViewController {
        let vc = CLRViewController(look: look, close: close)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = ""
        return vc
    }
}

// MARK: Private
private extension CLRViewController {
    func route(_ route: CLRViewModel.Route) {
        switch route {
        case .close:
            self.close()
        }
    }
    
    func addCloseButton() {
        closeButton.backgroundColor = UIColor.clear
        closeButton.setImage(UIImage(named: "CLR.Close"), for: .normal)
        
        let item = UIBarButtonItem(customView: closeButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 24.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 24.scale).isActive = true
        
        navigationItem.rightBarButtonItem = item
    }
}
