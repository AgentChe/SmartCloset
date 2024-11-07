//
//  SplashViewModel.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.08.2024.
//

import RxSwift
import RxCocoa

final class SplashViewModel {
    enum Route {
        case onboarding, paygateTransitionMain, main
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var sessionManager = SessionManager()
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension SplashViewModel {
    struct Input {
        let didSDKConfigured: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let login = login(didSDKConfigured: input.didSDKConfigured)
        
        return Output(
            route: makeRoute(login: login)
        )
    }
}

// MARK: Private
private extension SplashViewModel {
    func makeRoute(login: Signal<Void>) -> Driver<Route> {
        login
            .compactMap { [weak self] void -> Route? in
                guard let self else { return nil }
                
                guard OnboardingViewController.wasViewed() else { return .onboarding }
                
                guard sessionManager.hasActiveSubscriptions() else { return .paygateTransitionMain }
                
                return .main
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func login(didSDKConfigured: Signal<Void>) -> Signal<Void> {
        didSDKConfigured
            .flatMapLatest { [weak self] void -> Signal<Void> in
                guard let self else { return .never() }
                
                func source() -> Single<Void> {
                    let anonymousId = sessionManager.anonymousId
                    let internalId = sessionManager.internalId
                    
                    return (anonymousId == internalId) ? profileManager.create() : profileManager.binding()
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    tryAgain?(error) ?? .empty()
                }
                
                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .asSignal(onErrorSignalWith: .never())
            }
    }
}
