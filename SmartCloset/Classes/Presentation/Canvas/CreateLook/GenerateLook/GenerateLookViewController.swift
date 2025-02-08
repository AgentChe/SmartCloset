//
//  GenerateLookViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 07.02.2025.
//

import UIKit
import RxSwift

final class GenerateLookViewController: UIViewController {
    private lazy var mainView = GenerateLookView()
    
    private let viewModel: GenerateLookViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var closeButton = TapAreaButton()
    
    private let complete: (Look) -> Void
    private let close: () -> Void
    
    private init(
        lookItems: CreateLookViewController.LookItems,
        complete: @escaping (Look) -> Void,
        close: @escaping () -> Void
    ) {
        self.viewModel = GenerateLookViewModel(lookItems: lookItems)
        self.complete = complete
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
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            self?.open(error: error) ?? .never()
        }
        
        let output = viewModel.configure(input: GenerateLookViewModel.Input(
            didTapClose: closeButton.rx.tap.asSignal()
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension GenerateLookViewController {
    static func make(
        lookItems: CreateLookViewController.LookItems,
        complete: @escaping (Look) -> Void,
        close: @escaping () -> Void
    ) -> GenerateLookViewController {
        let vc = GenerateLookViewController(
            lookItems: lookItems,
            complete: complete,
            close: close
        )
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = ""
        return vc
    }
}

// MARK: Private
private extension GenerateLookViewController {
    func route(_ route: GenerateLookViewModel.Route) {
        switch route {
        case .close:
            self.close()
        case .complete(let look):
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: { [weak self] in
                self?.complete(look)
            })
        }
    }
    
    func addCloseButton() {
        closeButton.backgroundColor = UIColor.clear
        closeButton.setImage(UIImage(named: "GenerateLook.Close"), for: .normal)
        
        let item = UIBarButtonItem(customView: closeButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 44.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 44.scale).isActive = true
        
        navigationItem.rightBarButtonItem = item
    }
    
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self else { return Disposables.create() }
                
                let vc = TryAgainViewController.make(error: error) {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}
