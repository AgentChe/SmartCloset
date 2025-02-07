//
//  SIFCLViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 06.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SIFCLViewController: UIViewController {
    typealias Result = (ItemCategory, Item)
    
    private lazy var mainView = SIFCLView()
    
    private let viewModel: SIFCLViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var closeButton = TapAreaButton()
    
    private let result: (Result) -> Void
    private let close: (() -> Void)
    
    private init(
        itemCategory: ItemCategory,
        result: @escaping (Result) -> Void,
        close: @escaping (() -> Void)
    ) {
        self.viewModel = SIFCLViewModel(itemCategory: itemCategory)
        self.result = result
        self.close = close
        
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
        
        let output = viewModel.configure(input: SIFCLViewModel.Input(
            didSelectAttachment: mainView.attachmentView.didSelect,
            didTapClose: closeButton.rx.tap.asSignal(),
            didInputTextFilter: mainView.searchView.search,
            didScrollToBottom: mainView.collectionView.didScrollToBottom,
            didTapContinue: mainView.continueButton.rx.tap.asSignal()
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
    }
}

// MARK: Public
extension SIFCLViewController {
    static func make(
        itemCategory: ItemCategory,
        result: @escaping (Result) -> Void,
        close: @escaping (() -> Void)
    ) -> SIFCLViewController {
        let vc = SIFCLViewController(
            itemCategory: itemCategory,
            result: result,
            close: close
        )
        vc.navigationItem.title = "SIFCL.Title".localized
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension SIFCLViewController {
    func route(_ route: SIFCLViewModel.Route) {
        switch route {
        case .close:
            close()
        case .result(let result):
            self.result(result)
        }
    }
    
    func elements(_ elements: SIFCLViewModel.FetchElements) {
        switch elements {
        case .setup(let elements):
            mainView.collectionView.setup(elements: elements)
        case .append(let elements):
            mainView.collectionView.append(elements: elements)
        }
    }
    
    func addCloseButton() {
        closeButton.backgroundColor = UIColor.clear
        closeButton.setImage(UIImage(named: "SIFCL.Close"), for: .normal)
        
        let item = UIBarButtonItem(customView: closeButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 44.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 44.scale).isActive = true
        
        navigationItem.rightBarButtonItem = item
    }
}
