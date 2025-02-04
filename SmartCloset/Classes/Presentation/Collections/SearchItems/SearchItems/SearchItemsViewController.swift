//
//  SearchItemsViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 01.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchItemsViewController: UIViewController {
    private lazy var mainView = SearchItemsView()
    
    private lazy var viewModel = SearchItemsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var appliedFilterTrigger = PublishRelay<SIFilterViewController.Data>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else { return .never() }
            return open(error: error)
        }
        
        let output = viewModel.configure(input: SearchItemsViewModel.Input(
            didTapFilter: mainView.filterButton.rx.tap.asSignal(),
            appliedFilter: appliedFilterTrigger.asSignal(),
            search: mainView.inputField.search,
            didScrollToBottom: mainView.collectionView.didScrollToBottom,
            didTapFavorite: mainView.collectionView.didTapFavorite,
            didSelectItem: mainView.collectionView.didSelectItem
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.selectedFilterItemsCount
            .drive(Binder(mainView.filterButton) { base, count in
                base.setup(count: count)
            })
            .disposed(by: disposeBag)
        
        output.emptyMode
            .drive(Binder(mainView.emptyView) { base, mode in
                base.setup(mode: mode)
            })
            .disposed(by: disposeBag)
        
        output.emptyHidden
            .drive(mainView.emptyView.rx.isHidden)
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
    }
}

// MARK: Public
extension SearchItemsViewController {
    static func make() -> SearchItemsViewController {
        let vc = SearchItemsViewController()
        vc.navigationItem.title = "SearchItems.Title".localized
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension SearchItemsViewController {
    func action(_ action: SearchItemsViewModel.Action) {
        switch action {
        case .setup(let elements):
            mainView.collectionView.setup(elements: elements)
        case .append(let elements):
            mainView.collectionView.append(elements: elements)
        case .route(let route):
            self.route(route)
        case .changeFavorite(let itemId, let favorite):
            mainView.collectionView.change(favorite: favorite, id: itemId)
        }
    }
    
    func route(_ route: SearchItemsViewModel.Route) {
        switch route {
        case .openFilter(let data):
            let vc = SIFilterViewController.make(
                category: data.category,
                type: data.type,
                color: data.color,
                material: data.material
            ) { [weak self] data in
                self?.appliedFilterTrigger.accept(data)
            }
            present(vc, animated: true)
        case .openItem(let item):
            let vc = ItemViewController.make(item: item)
            navigationController?.pushViewController(vc, animated: true)
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
