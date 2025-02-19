//
//  ItemCategoryViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 04.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ItemCategoryViewController: UIViewController {
    private lazy var mainView = ItemCategoryView()
    
    private let viewModel: ItemCategoryViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didSelectItemTypeTrigger = PublishRelay<ItemType>()
    
    private init(itemCategory: ItemCategory) {
        viewModel = ItemCategoryViewModel(itemCategory: itemCategory)
        
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
            guard let self = self else { return .never() }
            return open(error: error)
        }
        
        let output = viewModel.configure(input: ItemCategoryViewModel.Input(
            didTapSelectType: mainView.selectTypeButton.rx.tap.asSignal(),
            didSelectItemType: didSelectItemTypeTrigger.asSignal(),
            didScrollToBottom: mainView.collectionView.didScrollToBottom,
            didTapFavorite: mainView.collectionView.didTapFavorite,
            didSelectItem: mainView.collectionView.didSelectItem
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.itemType
            .drive(Binder(mainView.selectTypeButton) { base, itemType in
                base.setup(itemType: itemType)
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(self) { base, elements in
                base.elements(elements)
            })
            .disposed(by: disposeBag)
        
        output.firstPageActivity
            .drive(Binder(mainView.centerPreloader) { base, activity in
                activity ? base.startAnimating() : base.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.paginationActivity
            .drive(Binder(mainView) { base, activity in
                base.collectionView.contentInset.bottom = activity ? 48.scale : 10.scale
                activity ? base.collectionPreloader.startAnimating() : base.collectionPreloader.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension ItemCategoryViewController {
    static func make(itemCategory: ItemCategory) -> ItemCategoryViewController {
        let vc = ItemCategoryViewController(itemCategory: itemCategory)
        vc.navigationItem.title = ItemCategory.DefaultLocalized().name(category: itemCategory)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension ItemCategoryViewController {
    func route(_ route: ItemCategoryViewModel.Route) {
        switch route {
        case .selectItemType(let itemCategory, let itemType):
            let vc = SITViewController.make(itemCategory: itemCategory, itemType: itemType, close: .pop) { [weak self] _, itemType  in
                self?.didSelectItemTypeTrigger.accept(itemType)
            }
            navigationController?.pushViewController(vc, animated: true)
        case .openItem(let item):
            let vc = ItemViewController.make(item: item)
            navigationController?.pushViewController(vc, animated: true)
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        }
    }
    
    func elements(_ elements: ItemCategoryViewModel.Elements) {
        switch elements {
        case .setup(let elements):
            mainView.collectionView.setup(elements: elements)
        case .append(let elements):
            mainView.collectionView.append(elements: elements)
        }
    }
    
    func action(_ action: ItemCategoryViewModel.Action) {
        switch action {
        case .changeFavorite(let itemId, let favorite):
            mainView.collectionView.change(favorite: favorite, id: itemId)
        }
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
