//
//  WardrobeViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 15.02.2025.
//

import RxSwift
import RxCocoa

final class WardrobeViewModel {
    enum Route {
        case settings
        case changeAvatar
    }
    
    private lazy var profileManager = ProfileManager()
    private lazy var discoveryManager = DiscoveryManager()
}

// MARK: Public
extension WardrobeViewModel {
    struct Input {
        let didTapSettings: Signal<Void>
        let didTapSelectNewAvatar: Signal<Void>
        let didSelectNewAvatar: Signal<UIImage>
        let didDeleteAvatar: Signal<Void>
        let didSelectTab: Signal<WardrobeTabItemButton.Tab>
    }
    
    struct Output {
        let route: Driver<Route>
        let profile: Driver<Profile>
        let disposable: Disposable
        let selectedTab: Driver<WardrobeTabItemButton.Tab>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(
                didTapSettings: input.didTapSettings,
                didTapSelectNewAvatar: input.didTapSelectNewAvatar
            ),
            profile: makeProfile(),
            disposable: makeDisposable(
                didSelectNewAvatar: input.didSelectNewAvatar,
                didDeleteAvatar: input.didDeleteAvatar
            ),
            selectedTab: makeSelectedTab(didSelectTab: input.didSelectTab)
        )
    }
}

// MARK: Private
private extension WardrobeViewModel {
    func makeRoute(
        didTapSettings: Signal<Void>,
        didTapSelectNewAvatar: Signal<Void>
    ) -> Driver<Route> {
        let settings = didTapSettings
            .map { Route.settings }
            .asDriver(onErrorDriveWith: .never())
        
        let changeAvatar = didTapSelectNewAvatar
            .map { Route.changeAvatar }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(settings, changeAvatar)
    }
    
    func makeProfile() -> Driver<Profile> {
        let triggers = Signal<Void>
            .merge(
                ProfileMediator.shared.didUpdateProfile.map { _ in Void() },
                ProfileMediator.shared.didUpdateName.map { _ in Void() },
                ProfileMediator.shared.didUpdateAvatar.map { _ in Void() },
                ProfileMediator.shared.didUpdateSize.map { _ in Void() },
                ProfileMediator.shared.didUpdateGender.map { _ in Void() },
                ProfileMediator.shared.didUpdateHeight.map { _ in Void() },
                ProfileMediator.shared.didUpdateOccasions.map { _ in Void() },
                ProfileMediator.shared.didUpdateSeason.map { _ in Void() }
            )
            .startWith(())
        
        return triggers
            .flatMapLatest { [weak self] void -> Driver<Profile> in
                guard let self else { return .never() }
                
                return profileManager
                    .obtainProfile(forceUpdate: false)
                    .compactMap { $0 }
                    .asDriver(onErrorDriveWith: .never())
            }
    }
    
    func makeDisposable(
        didSelectNewAvatar: Signal<UIImage>,
        didDeleteAvatar: Signal<Void>
    ) -> Disposable {
        let newAvatar = didSelectNewAvatar
            .flatMapLatest { [weak self] image -> Driver<URL> in
                guard let self else { return .never() }
                
                return discoveryManager
                    .upload(image: image, object: .avatar)
                    .compactMap { $0.url }
                    .asDriver(onErrorDriveWith: .never())
            }
            .flatMapLatest { [weak self] url -> Driver<Void> in
                guard let self else { return .never() }
                
                return profileManager
                    .update(avatar: url)
                    .mapToVoid()
                    .asDriver(onErrorDriveWith: .never())
            }
            .drive()
        
        let deleteAvatar = didDeleteAvatar
            .flatMapLatest { [weak self] void -> Driver<Void> in
                guard let self else { return .never() }
                
                return profileManager
                    .update(avatar: nil)
                    .mapToVoid()
                    .asDriver(onErrorDriveWith: .never())
            }
            .drive()
        
        return Disposables.create([newAvatar, deleteAvatar])
    }
    
    func makeSelectedTab(didSelectTab: Signal<WardrobeTabItemButton.Tab>) -> Driver<WardrobeTabItemButton.Tab> {
        didSelectTab
            .asDriver(onErrorDriveWith: .never())
            .startWith(.items)
    }
}
