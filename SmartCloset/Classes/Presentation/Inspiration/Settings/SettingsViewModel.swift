//
//  SettingsViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import RxSwift
import RxCocoa

final class SettingsViewModel {
    enum Route {
        case profile
        case open(URL)
    }
}

// MARK: Public
extension SettingsViewModel {
    struct Input {
        let didTapRoute: Signal<SettingsRouteButton.Route>
    }
    
    struct Output {
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(didTapRoute: input.didTapRoute)
        )
    }
}

// MARK: Private
private extension SettingsViewModel {
    func makeRoute(didTapRoute: Signal<SettingsRouteButton.Route>) -> Driver<Route>  {
        didTapRoute
            .map { route -> Route in
                switch route {
                case .profile:
                    return .profile
                case .termsOfUse:
                    return .open(GlobalDefinitions.termsOfServiceUrl)
                case .privacyPolicy:
                    return .open(GlobalDefinitions.privacyPolicyUrl)
                case .support:
                    return .open(GlobalDefinitions.contactUsUrl)
                }
            }
            .asDriver(onErrorDriveWith: .never())
    }
}
