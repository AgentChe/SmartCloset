//
//  CreateLookViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 07.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateLookViewController: UIViewController {
    typealias InputData = (ItemCategory, Item)
    
    struct LookItems {
        let tops: Item?
        let bottoms: Item?
        let shoes: Item?
        let bags: Item?
        let accessories: Item?
    }
    
    private lazy var mainView = CreateLookView()
    
    private let viewModel: CreateLookViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var closeButton = TapAreaButton()
    
    private lazy var didSelectItemFromList = PublishRelay<(ItemCategory, Item?)>()
    
    private let generateWithItems: (LookItems) -> Void
    private let close: (() -> Void)
    
    private init(
        inputData: InputData?,
        generateWithItems: @escaping (LookItems) -> Void,
        close: @escaping (() -> Void)
    ) {
        self.generateWithItems = generateWithItems
        self.close = close
        self.viewModel = CreateLookViewModel(inputData: inputData)
        
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
        
        let output = viewModel.configure(input: CreateLookViewModel.Input(
            didTapClose: closeButton.rx.tap.asSignal(),
            didTapGenerate: mainView.generateLookButton.rx.tap.asSignal(),
            didSelectItem: didSelectItem,
            didSelectItemCategory: didSelectItemCategory,
            didScrollToLast: didScrollToLast
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.canGenerateLook
            .map { !$0 }  
            .drive(mainView.generateLookButton.rx.isHidden)
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
    }
}

// MARK: Public
extension CreateLookViewController {
    static func make(
        inputData: InputData?,
        generateWithItems: @escaping (LookItems) -> Void,
        close: @escaping (() -> Void)
    ) -> CreateLookViewController {
        let vc = CreateLookViewController(
            inputData: inputData,
            generateWithItems: generateWithItems,
            close: close
        )
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "CreateLook.Title".localized
        return vc
    }
}

// MARK: Private
private extension CreateLookViewController {
    func route(_ route: CreateLookViewModel.Route) {
        switch route {
        case .close:
            close()
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
        case .createLook(let lookItems):
            generateWithItems(lookItems)
        }
    }
    
    func elements(_ elements: CreateLookViewModel.Elements, collectionView: CLItemsCollectionView) {
        switch elements {
        case .setup(let elements):
            collectionView.setup(elements: elements)
        case .append(let elements):
            collectionView.append(elements: elements)
        }
    }
    
    func addCloseButton() {
        closeButton.backgroundColor = UIColor.clear
        closeButton.setImage(UIImage(named: "CreateLook.Close"), for: .normal)
        
        let item = UIBarButtonItem(customView: closeButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 44.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 44.scale).isActive = true
        
        navigationItem.rightBarButtonItem = item
    }
}
