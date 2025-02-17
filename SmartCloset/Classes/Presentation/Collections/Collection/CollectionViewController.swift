//
//  CollectionViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 10.02.2025.
//

import UIKit
import RxSwift

final class CollectionViewController: UIViewController {
    private lazy var mainView = CollectionView()
    
    private let viewModel: CollectionViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var editButton = TapAreaButton()
    
    private init(collection: Collection) {
        viewModel = CollectionViewModel(collection: collection)
        
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
        
        addEditButton()
        
        let output = viewModel.configure(input: CollectionViewModel.Input(
            didTapEdit: editButton.rx.tap.asSignal(),
            didSelectLook: mainView.collectionView.didSelect
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.collectionView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.name
            .drive(Binder(self) { base, name in
                base.navigationItem.title = name
            })
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(mainView) { base, activity in
                activity ? base.preloader.startAnimating() : base.preloader.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.editAvailable
            .map { !$0 }
            .drive(editButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension CollectionViewController {
    static func make(collection: Collection) -> CollectionViewController {
        let vc = CollectionViewController(collection: collection)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension CollectionViewController {
    func route(_ route: CollectionViewModel.Route) {
        switch route {
        case .edit(let collection):
            let vc = EditCollectionViewController.make(collection: collection, delete: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            present(vc, animated: true)
        case .openLook(let look):
            let vc = LookViewController.make(look: look)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func addEditButton() {
        editButton.backgroundColor = UIColor.clear
        editButton.setImage(UIImage(named: "Collection.Edit"), for: .normal)
        
        let item = UIBarButtonItem(customView: editButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 44.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 44.scale).isActive = true
        
        navigationItem.rightBarButtonItem = item
    }
}
