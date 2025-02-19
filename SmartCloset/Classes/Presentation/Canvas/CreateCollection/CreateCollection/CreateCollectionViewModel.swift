//
//  CreateCollectionViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 10.02.2025.
//

import RxSwift
import RxCocoa

final class CreateCollectionViewModel {
    enum Route {
        case close
        case complete
        case paygate
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private let looks: Driver<[Look]>
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var collectionsManager = CollectionsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(looks: [Look]) {
        self.looks = BehaviorRelay(value: looks).asDriver()
    }
}

// MARK: Public
extension CreateCollectionViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didInputName: Signal<String?>
        let didTapCreate: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
        let enableCreate: Driver<Bool>
        let activity: Driver<Bool>
        let elements: Driver<[Look]>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(
                didTapClose: input.didTapClose,
                didTapCreate: input.didTapCreate,
                looks: looks,
                name: input.didInputName
            ),
            enableCreate: makeEnableCreate(didInputName: input.didInputName),
            activity: activity.asDriver(),
            elements: looks
        )
    }
}

// MARK: Private
private extension CreateCollectionViewModel {
    func makeRoute(
        didTapClose: Signal<Void>,
        didTapCreate: Signal<Void>,
        looks: Driver<[Look]>,
        name: Signal<String?>
    ) -> Driver<Route> {
        let close = didTapClose
            .map { Route.close }
            .asDriver(onErrorDriveWith: .never())
        
        let createOrPaygate = didTapCreate
            .withLatestFrom(looks)
            .withLatestFrom(name) { ($0, $1) }
            .flatMapLatest { [weak self] looks, name -> Driver<Route> in
                guard let self, let name else { return .never() }
                
                guard SessionManager().hasActiveSubscriptions() else {
                    return .just(Route.paygate)
                }
                
                func source() -> Single<Collection?> {
                    collectionsManager
                        .createCollection(
                            name: name,
                            looks: looks.map {  $0.id}
                        )
                        .map { collection -> Collection in
                            guard let collection else {
                                throw ContentError(.notContent)
                            }
                            
                            return collection
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
                    .trackActivity(activity)
                    .map { _ in Route.close }
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(close, createOrPaygate)
    }
    
    func makeEnableCreate(didInputName: Signal<String?>) -> Driver<Bool> {
        didInputName
            .map { !($0 ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .asDriver(onErrorDriveWith: .never())
            .startWith(false)
    }
}
