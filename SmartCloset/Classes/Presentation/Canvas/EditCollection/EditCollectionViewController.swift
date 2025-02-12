//
//  EditCollectionViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 10.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class EditCollectionViewController: UIViewController {
    private lazy var mainView = EditCollectionView()
    
    private let viewModel: EditCollectionViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var closeButton = TapAreaButton()
    
    private let delete: (() -> Void)?
    
    private lazy var didAddedLooksTrigger = PublishRelay<[Look]>()
    private lazy var didConfirmDeleteLookTrigger = PublishRelay<Look>()
    private lazy var didConfirmDeleteCollectionTrigger = PublishRelay<Void>()
    
    private init(collection: Collection, delete: (() -> Void)?) {
        self.viewModel = EditCollectionViewModel(collection: collection)
        self.delete = delete
        
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
        
        let output = viewModel.configure(input: EditCollectionViewModel.Input(
            didTapClose: closeButton.rx.tap.asSignal(),
            didTapSave: mainView.saveButton.rx.tap.asSignal(),
            didTapDeleteCollection: mainView.deleteButton.rx.tap.asSignal(),
            didConfirmDeleteCollection: didConfirmDeleteCollectionTrigger.asSignal(),
            didTapDeleteLook: mainView.collectionView.didTapDeleteLook,
            didConfirmDeleteLook: didConfirmDeleteLookTrigger.asSignal(),
            didTapAddLook: mainView.collectionView.didTapAddLook,
            didAddedLooks: didAddedLooksTrigger.asSignal(),
            didSelectLook: mainView.collectionView.didSelectLook,
            didInputName: mainView.textField.rx.text.asSignal(onErrorSignalWith: .never())
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.initialName
            .drive(mainView.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(mainView) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.collectionView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.canSave
            .drive(Binder(mainView) { base, canSave in
                base.canSave(canSave)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension EditCollectionViewController {
    static func make(collection: Collection, delete: (() -> Void)? = nil) -> NavigationController {
        let vc = EditCollectionViewController(collection: collection, delete: delete)
        vc.navigationItem.title = "EditCollection.Title".localized
        vc.navigationItem.backButtonTitle = " "
        
        let nc = NavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        
        return nc
    }
}

// MARK: Private
private extension EditCollectionViewController {
    func route(_ route: EditCollectionViewModel.Route) {
        switch route {
        case .dismiss:
            navigationController?.dismiss(animated: true)
        case .addLook(let selected):
            let vc = CCSelectLooksViewController.make(selectedLooksIds: selected, close: { [weak self] in
                self?.dismiss(animated: true)
            }, result: { [weak self] looks in
                self?.dismiss(animated: true) {
                    self?.didAddedLooksTrigger.accept(looks)
                }
            })
            
            let nc = NavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            
            present(nc, animated: true)
        case .openLook(let look):
            let vc = LookViewController.make(look: look)
            navigationController?.pushViewController(vc, animated: true)
        case .confirmDeleteLook(let look):
            let vc = ECConfirmDeleteViewController.make(look: look, remove: { [weak self] in
                self?.didConfirmDeleteLookTrigger.accept(look)
            })
            present(vc, animated: false)
        case .confirmDeleteCollection(let collection):
            let vc = ECConfirmDeleteViewController.make(collection: collection, remove: { [weak self] in
                self?.didConfirmDeleteCollectionTrigger.accept(Void())
            })
            present(vc, animated: false)
        case .deleted:
            navigationController?.dismiss(animated: true) { [weak self] in
                self?.delete?()
            }
        }
    }
    
    func addCloseButton() {
        closeButton.backgroundColor = UIColor.clear
        closeButton.setImage(UIImage(named: "Close.Black"), for: .normal)
        
        let item = UIBarButtonItem(customView: closeButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 44.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 44.scale).isActive = true
        
        navigationItem.leftBarButtonItem = item
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
