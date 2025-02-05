//
//  RecommendationsViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 05.02.2025.
//

import UIKit
import RxSwift

final class RecommendationsViewController: UIViewController {
    private lazy var mainView = RecommendationsView()
    
    private lazy var viewModel = RecommendationsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: RecommendationsViewModel.Input(
            didScrollToBottom: mainView.collectionView.didScrollToBottom,
            didSelectItem: mainView.collectionView.didSelectItem,
            didSelectLook: mainView.collectionView.didSelectLook
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
extension RecommendationsViewController {
    static func make() -> RecommendationsViewController {
        let vc = RecommendationsViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "Recommendations.Title".localized
        return vc
    }
}

// MARK: Private
private extension RecommendationsViewController {
    func elements(_ elements: RecommendationsViewModel.Elements) {
        switch elements {
        case .setup(let elements):
            mainView.collectionView.setup(elements: elements)
        case .append(let elements):
            mainView.collectionView.append(elements: elements)
        }
    }
    
    func route(_ route: RecommendationsViewModel.Route) {
        switch route {
        case .openItem(let item):
            let vc = ItemViewController.make(item: item)
            navigationController?.pushViewController(vc, animated: true)
        case .openLook(let look):
            print() // TODO
        }
    }
}
