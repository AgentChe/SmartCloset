//
//  MainViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 28.01.2025.
//

import UIKit
import RxSwift

final class MainViewController: UIViewController {
    lazy var mainView = MainView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var coordinator = MainCoordinator(parentVC: self)
    
    private let requestReview: Bool
    
    private init(requestReview: Bool) {
        self.requestReview = requestReview

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
        
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .bind(to: Binder(self) { base, _ in
                base.coordinator.change(tab: .inspiration)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge([
                mainView.tabView.inspirationButton
                    .rx.tap.map { TabView.Tab.inspiration },
                mainView.tabView.canvasButton
                    .rx.tap.map { TabView.Tab.canvas },
                mainView.tabView.wardrobeButton
                    .rx.tap.map { TabView.Tab.wardrobe }
            ])
            .bind(to: Binder(self) { base, tab in
                base.coordinator.change(tab: tab)
            })
            .disposed(by: disposeBag)
        
        if requestReview {
            RequestReview.request()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: Public
extension MainViewController {
    static func make(requestReview: Bool) -> MainViewController {
        let vc = MainViewController(requestReview: requestReview)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}
