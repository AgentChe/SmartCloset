//
//  EditLookViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 08.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class EditLookViewController: UIViewController {
    private lazy var mainView = EditLookView()
    
    private let viewModel: EditLookViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var closeButton = TapAreaButton()
    
    private lazy var didSelectItemFromList = PublishRelay<(ItemCategory, Item?)>()
    
    private init(look: Look) {
        self.viewModel = EditLookViewModel(look: look)
        
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
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            self?.open(error: error) ?? .never()
        }
        
        addCloseButton()
        
        let didSelectItem = Signal<(ItemCategory, Item?)>
            .merge(
                mainView.topsCollectionView.didSelectItem
                    .map { (ItemCategory.tops, $0) },
                mainView.bottomsCollectionView.didSelectItem
                    .map { (ItemCategory.bottoms, $0) },
                mainView.shoesCollectionView.didSelectItem
                    .map { (ItemCategory.shoes, $0) },
                mainView.bagsCollectionView.didSelectItem
                    .map { (ItemCategory.bags, $0) },
                mainView.accessoriesCollectionView.didSelectItem
                    .map { (ItemCategory.accessories, $0) },
                didSelectItemFromList.asSignal()
            )
        
        let didSelectItemCategory = Signal<ItemCategory>
            .merge(
                mainView.topsCollectionView.didSelectItemCategory,
                mainView.bottomsCollectionView.didSelectItemCategory,
                mainView.shoesCollectionView.didSelectItemCategory,
                mainView.bagsCollectionView.didSelectItemCategory,
                mainView.accessoriesCollectionView.didSelectItemCategory
            )
        
        let didScrollToLast = Signal<ItemCategory>
            .merge(
                mainView.topsCollectionView.didScrollToLast
                    .map { (ItemCategory.tops) },
                mainView.bottomsCollectionView.didScrollToLast
                    .map { (ItemCategory.bottoms) },
                mainView.shoesCollectionView.didScrollToLast
                    .map { (ItemCategory.shoes) },
                mainView.bagsCollectionView.didScrollToLast
                    .map { (ItemCategory.bags) },
                mainView.accessoriesCollectionView.didScrollToLast
                    .map { (ItemCategory.accessories) }
            )
        
        let output = viewModel.configure(input: EditLookViewModel.Input(
            didTapClose: closeButton.rx.tap.asSignal(),
            didTapSave: mainView.saveButton.rx.tap.asSignal(),
            didSelectItem: didSelectItem,
            didSelectItemCategory: didSelectItemCategory,
            didScrollToLast: didScrollToLast
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.canSaveLook
            .map { !$0 }
            .drive(mainView.saveButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.topsElements
            .drive(Binder(self) { base, elements in
                base.elements(elements, collectionView: base.mainView.topsCollectionView)
            })
            .disposed(by: disposeBag)
        
        output.bottomsElements
            .drive(Binder(self) { base, elements in
                base.elements(elements, collectionView: base.mainView.bottomsCollectionView)
            })
            .disposed(by: disposeBag)
        
        output.shoesElements
            .drive(Binder(self) { base, elements in
                base.elements(elements, collectionView: base.mainView.shoesCollectionView)
            })
            .disposed(by: disposeBag)
        
        output.bagsElements
            .drive(Binder(self) { base, elements in
                base.elements(elements, collectionView: base.mainView.bagsCollectionView)
            })
            .disposed(by: disposeBag)
        
        output.accessoriesElements
            .drive(Binder(self) { base, elements in
                base.elements(elements, collectionView: base.mainView.accessoriesCollectionView)
            })
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(mainView) { base, activity in
                activity ? base.preloader.startAnimating() : base.preloader.stopAnimating()
                base.saveButton.isHidden = activity
            }).disposed(by: disposeBag)
    }
}

// MARK: Public
extension EditLookViewController {
    static func make(look: Look) -> NavigationController {
        let vc = EditLookViewController(look: look)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "EditLook.Title".localized
        
        let nc = NavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        
        return nc
    }
}

// MARK: Private
private extension EditLookViewController {
    func route(_ route: EditLookViewModel.Route) {
        switch route {
        case .close:
            navigationController?.dismiss(animated: true)
        case .selectItem(let itemCategory):
            let nc = NavigationController()
            
            let vc = SIFCLViewController.make(itemCategory: itemCategory, result: { [weak self, weak nc] result in
                nc?.dismiss(animated: true) {
                    self?.didSelectItemFromList.accept(result)
                }
            }, close: { [weak nc] in
                nc?.dismiss(animated: true)
            })
            
            nc.setViewControllers([vc], animated: false)
            nc.modalPresentationStyle = .fullScreen
            
            present(nc, animated: true)
        }
    }
    
    func elements(_ elements: EditLookViewModel.Elements, collectionView: CLItemsCollectionView) {
        switch elements {
        case .setup(let elements):
            collectionView.setup(elements: elements)
        case .append(let elements):
            collectionView.append(elements: elements)
        }
    }
    
    func addCloseButton() {
        closeButton.backgroundColor = UIColor.clear
        closeButton.setImage(UIImage(named: "Close.Black"), for: .normal)
        
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
