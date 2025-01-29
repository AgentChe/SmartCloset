//
//  OnboardingViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class OnboardingViewController: UIViewController {
    struct Constants {
        static let wasViewedKey = "onboarding_view_controller_was_viewed_key"
    }
    
    private lazy var mainView = OnboardingView { [weak self] profile in
        guard let self else { return }
        
        collectedProfileTrigger.accept(profile)
    }
    
    private lazy var viewModel = OnboardingViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var collectedProfileTrigger = PublishRelay<Profile>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else { return .never() }
            return open(error: error)
        }
        
        let output = viewModel.configure(input: OnboardingViewModel.Input(
            collectedProfile: collectedProfileTrigger.asSignal()
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension OnboardingViewController {
    static func make() -> OnboardingViewController {
        OnboardingViewController()
    }
    
    static func wasViewed() -> Bool {
        UserDefaults.standard.bool(forKey: OnboardingViewController.Constants.wasViewedKey)
    }
}

// MARK: Private
private extension OnboardingViewController {
    func route(_ route: OnboardingViewModel.Route) {
        switch route {
        case .main:
            markAsViewed()
            
            let vc = MainViewController.make(requestReview: true)
            let nc = NavigationController(rootViewController: vc)
            UIApplication.shared.keyWindow?.rootViewController = nc
        case .paygateWithAfterMain:
            let vc = PaygateViewController.make { [weak self] in
                self?.route(.main)
            }
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
    
    func markAsViewed() {
        UserDefaults.standard.setValue(true, forKey: Constants.wasViewedKey)
    }
}
