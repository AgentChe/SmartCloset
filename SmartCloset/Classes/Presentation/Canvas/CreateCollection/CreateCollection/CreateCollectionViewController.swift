//
//  CreateCollectionViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 10.02.2025.
//

import UIKit
import RxSwift

final class CreateCollectionViewController: UIViewController {
    private lazy var mainView = CreateCollectionView()
    
    private let viewModel: CreateCollectionViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var closeButton = TapAreaButton()
    
    private let close: () -> Void
    
    private init(looks: [Look], close: @escaping () -> Void) {
        self.viewModel = CreateCollectionViewModel(looks: looks)
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
            guard let self = self else { return .never() }
            return open(error: error)
        }
        
        let output = viewModel.configure(input: CreateCollectionViewModel.Input(
            didTapClose: closeButton.rx.tap.asSignal(),
            didInputName: mainView.textField.rx.text.asSignal(onErrorSignalWith: .never()),
            didTapCreate: mainView.createCollectionButton.rx.tap.asSignal()
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.enableCreate
            .drive(Binder(mainView) { base, enable in
                base.setup(enableCreate: enable)
            })
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(mainView) { base, activity in
                base.createCollectionButton.isHidden = activity
                activity ? base.preloader.startAnimating() : base.preloader.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.collectionView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.textField.becomeFirstResponder()
    }
}

// MARK: Public
extension CreateCollectionViewController {
    static func make(
        looks: [Look], close: @escaping () -> Void) -> CreateCollectionViewController {
        let vc = CreateCollectionViewController(looks: looks, close: close)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "CreateCollection.Title".localized
        return vc
    }
}

// MARK: Private
private extension CreateCollectionViewController {
    func route(_ route: CreateCollectionViewModel.Route) {
        switch route {
        case .close, .complete:
            close()
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
    
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make(error: error) {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}
