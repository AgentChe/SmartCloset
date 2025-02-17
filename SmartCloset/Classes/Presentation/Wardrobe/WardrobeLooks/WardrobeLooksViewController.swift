//
//  WardrobeLooksViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 16.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class WardrobeLooksViewController: UIViewController {
    private lazy var mainView = WardrobeLooksView()
    
    private lazy var viewModel = WardrobeLooksViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didForceUpdateTrigger = PublishRelay<Void>()
    
    private let openLook: (Look) -> Void
    private let openFavoritesList: () -> Void
    private let openAllList: () -> Void
    private let createLook: () -> Void
    
    private init(
        openLook: @escaping (Look) -> Void,
        openFavoritesList: @escaping () -> Void,
        openAllList: @escaping () -> Void,
        createLook: @escaping () -> Void
    ) {
        self.openLook = openLook
        self.openFavoritesList = openFavoritesList
        self.openAllList = openAllList
        self.createLook = createLook
        
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
        
        let output = viewModel.configure(input: WardrobeLooksViewModel.Input(
            didForceUpdate: didForceUpdateTrigger.asSignal(),
            didSelect: mainView.tableView.didSelectLook,
            didTapSeeMore: mainView.tableView.didTapSeeMore,
            didTapCreateLook: mainView.emptyView.addButton.rx.tap.asSignal()
        ))
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(mainView.preloader) { base, activity in
                activity ? base.startAnimating() : base.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.isEmpty
            .map { !$0 }
            .drive(mainView.emptyView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension WardrobeLooksViewController {
    static func make(
        openLook: @escaping (Look) -> Void,
        openFavoritesList: @escaping () -> Void,
        openAllList: @escaping () -> Void,
        createLook: @escaping () -> Void
    ) -> WardrobeLooksViewController {
        WardrobeLooksViewController(
            openLook: openLook,
            openFavoritesList: openFavoritesList,
            openAllList: openAllList,
            createLook: createLook
        )
    }
}

// MARK: Private
private extension WardrobeLooksViewController {
    func route(_ route: WardrobeLooksViewModel.Route) {
        switch route {
        case .openLook(let look):
            self.openLook(look)
        case .openAll:
            self.openAllList()
        case .openFavorites:
            self.openFavoritesList()
        case .createLook:
            self.createLook()
        }
    }
}
