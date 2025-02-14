//
//  ItemViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 04.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ItemViewController: UIViewController {
    private lazy var mainView = ItemView()
    
    private let viewModel: ItemViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var deleteButton = TapAreaButton()
    
    private lazy var didTapWardrobeTrigger = PublishRelay<Bool>()
    private lazy var didConfirmDeleteTrigger = PublishRelay<Void>()
    
    private init(item: Item) {
        viewModel = ItemViewModel(item: item)
        
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
        
        addDeleteButton()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else { return .never() }
            return open(error: error)
        }
        
        let output = viewModel.configure(input: ItemViewModel.Input(
            didTapWardrobe: didTapWardrobeTrigger.asSignal(),
            didTapDelete: deleteButton.rx.tap.asSignal(),
            didConfirmDelete: didConfirmDeleteTrigger.asSignal()
        ))
        
        let isWardrobe = output.isWardrobe
        
        mainView.wardrobeButton.rx.tap
            .withLatestFrom(isWardrobe)
            .bind(to: didTapWardrobeTrigger)
            .disposed(by: disposeBag)
        
        isWardrobe
            .drive(Binder(mainView) { base, isWardrobe in
                base.wardrobe(isWardrobe)
            })
            .disposed(by: disposeBag)
        
        output.wardrobeAvailable
            .map { !$0 }
            .drive(mainView.wardrobeButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.deleteAvailable
            .map { !$0 }
            .drive(deleteButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(mainView.preloader) { base, activity in
                activity ? base.startAnimating() : base.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension ItemViewController {
    static func make(item: Item) -> ItemViewController {
        let vc = ItemViewController(item: item)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = item.name
        return vc
    }
}

// MARK: Private
private extension ItemViewController {
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
    
    func addDeleteButton() {
        deleteButton.backgroundColor = UIColor.clear
        deleteButton.setImage(UIImage(named: "Item.Delete"), for: .normal)
        
        let item = UIBarButtonItem(customView: deleteButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 24.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 24.scale).isActive = true
        
        navigationItem.rightBarButtonItem = item
    }
    
    func route(_ route: ItemViewModel.Route) {
        switch route {
        case .close:
            navigationController?.popViewController(animated: true)
        case .confirmDelete(let item):
            let vc = CDItemViewController.make(item: item, remove: { [weak self] in
                self?.didConfirmDeleteTrigger.accept(Void())
            })
            present(vc, animated: false)
        }
    }
}
