//
//  LooksViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 17.02.2025.
//

import UIKit
import RxSwift

final class LooksViewController: UIViewController {
    private lazy var mainView = LooksView()
    
    private let viewModel: LooksViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private init(
        attachment: GetCollectionsRequest.Attachment,
        favorite: Bool?
    ) {
        viewModel = LooksViewModel(
            attachment: attachment,
            favorite: favorite
        )
        
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
        
        let output = viewModel.configure(input: LooksViewModel.Input(
            didScrollToBottom: mainView.collectionView.didScrollToBottom,
            didTapFavorite: mainView.collectionView.didTapFavorite,
            didSelectLook: mainView.collectionView.didSelectLook
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
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
    }
}

// MARK: Public
extension LooksViewController {
    static func favorites() -> LooksViewController {
        let vc = LooksViewController(attachment: .wardrobe, favorite: true)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "Looks.Title.Favorites".localized
        return vc
    }
    
    static func allWardrobe() -> LooksViewController {
        let vc = LooksViewController(attachment: .wardrobe, favorite: nil)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "Looks.Title.AllCustom".localized
        return vc
    }
}

// MARK: Private
private extension LooksViewController {
    func action(_ action: LooksViewModel.Action) {
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
    
    func route(_ route: LooksViewModel.Route) {
        switch route {
        case .openLook(let look):
            let vc = LookViewController.make(look: look)
            navigationController?.pushViewController(vc, animated: true)
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
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
