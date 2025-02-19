//
//  AddItemToWardrobeViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 13.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class AddItemToWardrobeViewController: UIViewController {
    private lazy var mainView = AddItemToWardrobeView()
    
    private lazy var viewModel = AddItemToWardrobeViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var closeButton = TapAreaButton()
    
    private lazy var didSelectItemTypeTrigger = PublishRelay<ItemType>()
    
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
        
        let output = viewModel.configure(input: AddItemToWardrobeViewModel.Input(
            didTapClose: closeButton.rx.tap.asSignal(),
            didSelectCategory: mainView.categoriesView.didSelect,
            didTapSelectType: mainView.selectTypeButton.rx.tap.asSignal(),
            didSelectItemType: didSelectItemTypeTrigger.asSignal(),
            didScrollToBottom: mainView.collectionView.didScrollToBottom,
            didTapSave: mainView.saveButton.rx.tap.asSignal(),
            didChangeSelect: mainView.collectionView.didChangeSelected
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.itemCategory
            .drive(Binder(mainView.categoriesView) { base, category in
                base.setup(category: category)
            })
            .disposed(by: disposeBag)
        
        output.itemType
            .drive(Binder(mainView.selectTypeButton) { base, itemType in
                base.setup(itemType: itemType)
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
        
        output.elements
            .drive(Binder(self) { base, elements in
                base.elements(elements)
            })
            .disposed(by: disposeBag)
        
        output.canSave
            .drive(Binder(mainView) { base, canSave in
                base.canSave(canSave)
            })
            .disposed(by: disposeBag)
        
        output.saveActivity
            .drive(Binder(mainView) { base, activity in
                base.saveButton.isHidden = activity
                activity ? base.savePreloader.startAnimating() : base.savePreloader.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension AddItemToWardrobeViewController {
    static func make() -> AddItemToWardrobeViewController {
        let vc = AddItemToWardrobeViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "AddItemToWardrobe.Title".localized
        return vc
    }
}

// MARK: Private
private extension AddItemToWardrobeViewController {
    func route(_ route: AddItemToWardrobeViewModel.Route) {
        switch route {
        case .close:
            navigationController?.dismiss(animated: true)
        case .selectItemType(let itemCategory, let itemType):
            let vc = SITViewController.make(itemCategory: itemCategory, itemType: itemType, close: .pop) { [weak self] _, itemType  in
                self?.didSelectItemTypeTrigger.accept(itemType)
            }
            navigationController?.pushViewController(vc, animated: true)
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        }
    }
    
    func elements(_ elements: AddItemToWardrobeViewModel.Elements) {
        switch elements {
        case .setup(let elements):
            mainView.collectionView.setup(elements: elements)
        case .append(let elements):
            mainView.collectionView.append(elements: elements)
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
