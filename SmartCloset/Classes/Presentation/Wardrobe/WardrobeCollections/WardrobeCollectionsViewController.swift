//
//  WardrobeCollectionsViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 16.02.2025.
//

import UIKit
import RxSwift

final class WardrobeCollectionsViewController: UIViewController {
    private lazy var mainView = WardrobeCollectionsView()
    
    private lazy var viewModel = WardrobeCollectionsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let openCollection: (Collection) -> Void
    
    init(openCollection: @escaping (Collection) -> Void) {
        self.openCollection = openCollection
        
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
        
        let output = viewModel.configure(input: WardrobeCollectionsViewModel.Input(
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
extension WardrobeCollectionsViewController {
    static func make(openCollection: @escaping (Collection) -> Void) -> WardrobeCollectionsViewController {
        WardrobeCollectionsViewController(openCollection: openCollection)
    }
}

// MARK: Private
private extension WardrobeCollectionsViewController {
    func elements(_ elements: WardrobeCollectionsViewModel.Elements) {
        switch elements {
        case .setup(let elements):
            mainView.collectionView.setup(elements: elements)
        case .append(let elements):
            mainView.collectionView.append(elements: elements)
        }
    }
    
    func route(_ route: WardrobeCollectionsViewModel.Route) {
        switch route {
        case .openCollection(let collection):
            self.openCollection(collection)
        }
    }
}
