//
//  CollectionsViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 17.02.2025.
//

import UIKit
import RxSwift

final class CollectionsViewController: UIViewController {
    private lazy var mainView = CollectionsView()
    
    private lazy var viewModel = CollectionsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: CollectionsViewModel.Input(
            didScrollToBottom: mainView.collectionView.didScrollToBottom,
            didSelectCollection: mainView.collectionView.didSelectCollection
        ))
        
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
                base.collectionView.contentInset.bottom = activity ? 48.scale : 20.scale
                activity ? base.collectionPreloader.startAnimating() : base.collectionPreloader.stopAnimating()
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
extension CollectionsViewController {
    static func make() -> CollectionsViewController {
        let vc = CollectionsViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "Collections.Title".localized
        return vc
    }
}

// MARK: Private
private extension CollectionsViewController {
    func elements(_ elements: CollectionsViewModel.Elements) {
        switch elements {
        case .setup(let elements):
            mainView.collectionView.setup(elements: elements)
        case .append(let elements):
            mainView.collectionView.append(elements: elements)
        }
    }
    
    func route(_ route: CollectionsViewModel.Route) {
        switch route {
        case .openCollection(let collection):
            let vc = CollectionViewController.make(collection: collection)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
