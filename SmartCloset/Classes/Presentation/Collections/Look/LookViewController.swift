//
//  LookViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 05.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class LookViewController: UIViewController {
    private lazy var mainView = LookView()
    
    private let viewModel: LookViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var deleteButton = TapAreaButton()
    private lazy var favoriteButton = TapAreaButton()
    
    private lazy var didTapWardrobeTrigger = PublishRelay<Bool>()
    private lazy var didConfirmDeleteTrigger = PublishRelay<Void>()
    private lazy var didTapChangeFavorite = PublishRelay<Bool>()
    
    private init(look: Look) {
        viewModel = LookViewModel(look: look)
        
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
        
        addNavButtons()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else { return .never() }
            return open(error: error)
        }
        
        let didSelectItem = Signal
            .merge(
                mainView.collectionView.didSelectItem,
                mainView.itemsView.didTapItem
            )
        
        let output = viewModel.configure(input: LookViewModel.Input(
            didSelectItem: didSelectItem,
            didTapFavorite: didTapChangeFavorite.asSignal(),
            didTapShare: mainView.shareButton.rx.tap.asSignal(),
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
        
        let isFavorite = output.isFavorite
        
        favoriteButton.rx.tap
            .withLatestFrom(isFavorite)
            .bind(to: didTapChangeFavorite)
            .disposed(by: disposeBag)
        
        isFavorite
            .drive(Binder(self) { base, isFavorite in
                base.favorite(isFavorite)
            })
            .disposed(by: disposeBag)
        
        output.itemsElements
            .drive(Binder(mainView.collectionView) { base, items in
                base.setup(elements: items)
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
        
        output.look
            .drive(Binder(mainView.itemsView) { base, look in
                base.setup(look: look)
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(mainView) { base, activity in
                base.shareButton.isHidden = activity
                activity ? base.preloader.startAnimating() : base.preloader.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension LookViewController {
    static func make(look: Look) -> LookViewController {
        let vc = LookViewController(look: look)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "Look.Title".localized
        return vc
    }
}

// MARK: Private
private extension LookViewController {
    func route(_ route: LookViewModel.Route) {
        switch route {
        case .close:
            navigationController?.popViewController(animated: true)
        case .openItem(let item):
            let vc = ItemViewController.make(item: item)
            navigationController?.pushViewController(vc, animated: true)
        case .confirmDelete(let look):
            let vc = ECConfirmDeleteViewController.make(look: look, remove: { [weak self] in
                self?.didConfirmDeleteTrigger.accept(Void())
            })
            present(vc, animated: false)
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        }
    }
    
    func action(_ action: LookViewModel.Action) {
        switch action {
        case .share:
            let bounds = mainView.itemsView.bounds
            
            UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0)
            mainView.itemsView.drawHierarchy(in: bounds, afterScreenUpdates: false)
            let snapshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            guard let snapshot else { return }
            
            let vc = UIActivityViewController(activityItems: [snapshot], applicationActivities: nil)
            present(vc, animated: true)
        }
    }
    
    func favorite(_ favorite: Bool) {
        let iconName = favorite ? "Look.Favorite.T" : "Look.Favorite.F"
        favoriteButton.setImage(UIImage(named: iconName), for: .normal)
    }
    
    func addNavButtons() {
        deleteButton.backgroundColor = UIColor.clear
        deleteButton.setImage(UIImage(named: "Look.Delete"), for: .normal)
        favoriteButton.backgroundColor = UIColor.clear
        
        let deleteItem = UIBarButtonItem(customView: deleteButton)
        deleteItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        let favoriteItem = UIBarButtonItem(customView: favoriteButton)
        favoriteItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        deleteItem.customView?.widthAnchor.constraint(equalToConstant: 32.scale).isActive = true
        deleteItem.customView?.heightAnchor.constraint(equalToConstant: 32.scale).isActive = true
        favoriteItem.customView?.widthAnchor.constraint(equalToConstant: 32.scale).isActive = true
        favoriteItem.customView?.heightAnchor.constraint(equalToConstant: 32.scale).isActive = true
        
        navigationItem.rightBarButtonItems = [favoriteItem, deleteItem]
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
