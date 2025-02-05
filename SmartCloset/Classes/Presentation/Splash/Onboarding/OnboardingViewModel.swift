//
//  OnboardingViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 28.01.2025.
//

import RxSwift
import RxCocoa

final class OnboardingViewModel {
    enum Route {
        case paygateWithAfterMain
        case main
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension OnboardingViewModel {
    struct Input {
        let collectedProfile: Signal<Profile>
    }
    
    struct Output {
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(collectedProfile: input.collectedProfile)
        )
    }
}

// MARK: Private
private extension OnboardingViewModel {
    func makeRoute(collectedProfile: Signal<Profile>) -> Driver<Route> {
        collectedProfile
            .flatMapFirst { [weak self] profile -> Driver<Void> in
                guard let self else { return .never() }
                
                func source() -> Single<Void> {
                    profileManager
                        .setup(profile: profile)
                        .flatMap { result -> Single<Void> in
                            guard result.success else { return .error(ContentError(.notContent)) }
                            return .just(Void())
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .asDriver(onErrorDriveWith: .never())
            }
            .map { void -> Route in
                SessionManager().hasActiveSubscriptions() ? .main : .paygateWithAfterMain
            }
    }
}
