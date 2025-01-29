//
//  SettingsViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingsViewController: UIViewController {
    private lazy var mainView = SettingsView()
    
    private lazy var viewModel = SettingsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let didTapRoute = Signal<SettingsRouteButton.Route>
            .merge(
                mainView.profileButton.rx.tap
                    .map { SettingsRouteButton.Route.profile }
                    .asSignal(onErrorSignalWith: .never()),
                mainView.termsOfUseButton.rx.tap
                    .map { SettingsRouteButton.Route.termsOfUse }
                    .asSignal(onErrorSignalWith: .never()),
                mainView.privacyPolicyButton.rx.tap
                    .map { SettingsRouteButton.Route.privacyPolicy }
                    .asSignal(onErrorSignalWith: .never()),
                mainView.supportButton.rx.tap
                    .map { SettingsRouteButton.Route.support }
                    .asSignal(onErrorSignalWith: .never())
            )
        
        let output = viewModel.configure(input: SettingsViewModel.Input(
            didTapRoute: didTapRoute
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension SettingsViewController {
    static func make() -> SettingsViewController {
        let vc = SettingsViewController()
        vc.navigationItem.title = "Settings.Title".localized
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension SettingsViewController {
    func route(_ route: SettingsViewModel.Route) {
        switch route {
        case .profile:
            break // TODO
        case .open(let url):
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
