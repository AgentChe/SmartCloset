//
//  ChangeProfileViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 30.01.2025.
//

import RxSwift
import RxCocoa

final class ChangeProfileViewModel {
    enum Route {
        case close
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension ChangeProfileViewModel {
    struct Input {
        let changedField: Signal<ChangeProfileFieldView.ChangedField>
    }
    
    struct Output {
        let activity: Driver<Bool>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            activity: activity.asDriver(),
            route: makeRoute(changedField: input.changedField)
        )
    }
}

// MARK: Private
private extension ChangeProfileViewModel {
    func makeRoute(changedField: Signal<ChangeProfileFieldView.ChangedField>) -> Driver<Route> {
        changedField
            .flatMapLatest { [weak self] field -> Driver<Route> in
                guard let self else { return .never() }
                
                func source() -> Single<Void> {
                    switch field {
                    case .name(let name):
                        return profileManager
                            .update(name: name)
                    case .size(let size):
                        return profileManager
                            .update(size: size)
                    case .gender(let gender):
                        return profileManager
                            .update(gender: gender)
                    case .height(let height):
                        return profileManager
                            .update(height: height)
                    case .occasions(let occasions):
                        return profileManager
                            .update(occasions: occasions)
                    case .seasons(let seasons):
                        return profileManager
                            .update(seasons: seasons)
                    }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    tryAgain?(error) ?? .empty()
                }
                
                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .trackActivity(activity)
                    .map { Route.close }
                    .asDriver(onErrorDriveWith: .never())
            }
    }
}
