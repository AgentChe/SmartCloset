//
//  WardrobeItemsViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 16.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class WardrobeItemsViewController: UIViewController {
    private lazy var mainView = WardrobeItemsView()
    
    private lazy var viewModel = WardrobeItemsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didSelectItemTypeTrigger = PublishRelay<ItemType>()
    
    private let openItem: (Item) -> Void
    private let createItem: () -> Void
    private let isEmpty: (Bool) -> Void
    
    private init(
        openItem: @escaping (Item) -> Void,
        createItem: @escaping () -> Void,
        isEmpty: @escaping (Bool) -> Void
    ) {
        self.openItem = openItem
        self.createItem = createItem
        self.isEmpty = isEmpty
        
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
        
        let output = viewModel.configure(input: WardrobeItemsViewModel.Input(
            didSelectCategory: mainView.collectionView.didSelectCategory,
            didTapSelectType: mainView.collectionView.didTapSelectType,
            didSelectItemType: didSelectItemTypeTrigger.asSignal(),
            didTapFavoriteMode: mainView.collectionView.didTapFavoriteMode,
            didChangeFavoriteElement: mainView.collectionView.didTapFavorite,
            didScrollToBottom: mainView.collectionView.didScrollToBottom,
            didTapFavorite: mainView.collectionView.didTapFavorite,
            didTapItem: mainView.collectionView.didSelectItem,
            didTapCreateItem: mainView.emptyView.addButton.rx.tap.asSignal()
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.itemCategory
            .drive(Binder(mainView.collectionView) { base, category in
                base.setup(itemCategory: category)
            })
            .disposed(by: disposeBag)
        
        output.itemType
            .drive(Binder(mainView.collectionView) { base, itemType in
                base.setup(itemType: itemType)
            })
            .disposed(by: disposeBag)
        
        output.isFavoriteMode
            .drive(Binder(mainView.collectionView) { base, favorite in
                base.setup(favoriteMode: favorite)
            })
            .disposed(by: disposeBag)
        
        output.firstPageActivity
            .drive(Binder(mainView.centerPreloader) { base, activity in
                activity ? base.startAnimating() : base.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.paginationActivity
            .drive(Binder(mainView.collectionPreloader) { base, activity in
                activity ? base.startAnimating() : base.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(self) { base, elements in
                base.elements(elements)
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.isEmpty
            .drive(Binder(self) { base, isEmpty in
                base.mainView.emptyView.isHidden = !isEmpty
                base.isEmpty(isEmpty)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension WardrobeItemsViewController {
    static func make(
        openItem: @escaping (Item) -> Void,
        createItem: @escaping () -> Void,
        isEmpty: @escaping (Bool) -> Void
    ) -> WardrobeItemsViewController {
        WardrobeItemsViewController(
            openItem: openItem,
            createItem: createItem,
            isEmpty: isEmpty
        )
    }
}

// MARK: Private
private extension WardrobeItemsViewController {
    func route(_ route: WardrobeItemsViewModel.Route) {
        switch route {
        case .selectItemType(let itemCategory, let itemType):
            let vc = SITViewController.make(itemCategory: itemCategory, itemType: itemType, close: .pop) { [weak self] _, itemType  in
                self?.didSelectItemTypeTrigger.accept(itemType)
            }
            navigationController?.pushViewController(vc, animated: true)
        case .openItem(let item):
            self.openItem(item)
        case .createItem:
            self.createItem()
        }
    }
    
    func elements(_ elements: WardrobeItemsViewModel.Elements) {
        switch elements {
        case .setup(let elements):
            mainView.collectionView.setup(elements: elements)
        case .append(let elements):
            mainView.collectionView.append(elements: elements)
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
    
    func action(_ action: WardrobeItemsViewModel.Action) {
        switch action {
        case .changeFavorite(let itemId, let favorite):
            mainView.collectionView.change(favorite: favorite, id: itemId)
        }
    }
}
