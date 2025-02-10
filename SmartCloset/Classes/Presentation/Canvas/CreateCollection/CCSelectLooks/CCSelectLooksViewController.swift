//
//  CCSelectLooksViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 09.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CCSelectLooksViewController: UIViewController {
    private lazy var mainView = CCSelectLooksView()
    
    private let viewModel: CCSelectLooksViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var closeButton = TapAreaButton()
    
    private lazy var didForceUpdateTrigger = PublishRelay<Void>()
    
    private let close: () -> Void
    private let result: ([Look]) -> Void
    
    private init(
        selectedLooksIds: [String],
        close: @escaping () -> Void,
        result: @escaping ([Look]) -> Void
    ) {
        self.viewModel = CCSelectLooksViewModel(selectedLooksIds: selectedLooksIds)
        self.close = close
        self.result = result
        
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
        
        addCloseButton()
        
        let output = viewModel.configure(input: CCSelectLooksViewModel.Input(
            didSelectAttachment: mainView.attachmentView.didSelect,
            didTapClose: closeButton.rx.tap.asSignal(),
            didTapChangeFavoriteFilter: mainView.favoriteSwitch.button.rx.tap.asSignal(),
            didScrollToBottom: mainView.collectionView.didScrollToBottom,
            didSelectElement: mainView.collectionView.didChangeSelectedElements,
            didTapConfirmSelectedLooks: mainView.continueButton.rx.tap.asSignal(),
            didTapCreateLook: mainView.emptyView.createLookButton.rx.tap.asSignal(),
            didForceUpdate: didForceUpdateTrigger.asSignal()
        ))
        
        output.attachment
            .drive(Binder(mainView.attachmentView) { base, attachment in
                base.setup(attachment: attachment)
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.onlyFavorite
            .drive(Binder(mainView.favoriteSwitch) { base, onlyFavorite in
                base.setup(select: onlyFavorite)
            })
            .disposed(by: disposeBag)
        
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
        
        output.countSelectedElements
            .drive(Binder(mainView) { base, count in
                base.setup(continueEnable: count > 0)
                base.attachmentView.setup(selectedCount: count)
            })
            .disposed(by: disposeBag)
        
        output.isEmpty
            .map { !$0 }
            .drive(mainView.emptyView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension CCSelectLooksViewController {
    static func make(
        selectedLooksIds: [String],
        close: @escaping () -> Void,
        result: @escaping ([Look]) -> Void
    ) -> CCSelectLooksViewController {
        let vc = CCSelectLooksViewController(
            selectedLooksIds: selectedLooksIds,
            close: close,
            result: result
        )
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "CCSelectLooks.Title".localized
        return vc
    }
}

// MARK: Private
private extension CCSelectLooksViewController {
    func elements(_ elements: CCSelectLooksViewModel.FetchElements) {
        switch elements {
        case .setup(let elements):
            mainView.collectionView.setup(elements: elements)
        case .append(let elements):
            mainView.collectionView.append(elements: elements)
        }
    }
    
    func route(_ route: CCSelectLooksViewModel.Route) {
        switch route {
        case .close:
            self.close()
        case .result(let looks):
            self.result(looks)
        case .createLook:
            CreateLookAssembly().create(from: self) { [weak self] _ in
                self?.didForceUpdateTrigger.accept(Void())
            }
        }
    }
    
    func addCloseButton() {
        closeButton.backgroundColor = UIColor.clear
        closeButton.setImage(UIImage(named: "Close.Black"), for: .normal)
        
        let item = UIBarButtonItem(customView: closeButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 24.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 24.scale).isActive = true
        
        navigationItem.rightBarButtonItem = item
    }
}
