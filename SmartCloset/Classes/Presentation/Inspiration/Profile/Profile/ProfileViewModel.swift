//
//  ProfileViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import RxSwift
import RxCocoa

final class ProfileViewModel {
    enum Route {
        case changeAvatar
        case changeName
        case changeSize
        case changeGender
        case changeHeight
        case changeOccasion
        case changeSeasons
    }
    
    private lazy var profileManager = ProfileManager()
    private lazy var discoveryManager = DiscoveryManager()
}

// MARK: Public
extension ProfileViewModel {
    struct Input {
        let didSelect: Signal<ProfileTableElement>
        let didSelectNewAvatar: Signal<UIImage>
        let didDeleteAvatar: Signal<Void>
    }
    
    struct Output {
        let elements: Driver<[ProfileTableElement]>
        let route: Driver<Route>
        let disposable: Disposable
    }
    
    func configure(input: Input) -> Output {
        let profile = makeProfile()
        
        return Output(
            elements: makeElements(profile: profile),
            route: makeRoute(didSelect: input.didSelect),
            disposable: makeDisposable(
                didSelectNewAvatar: input.didSelectNewAvatar,
                didDeleteAvatar: input.didDeleteAvatar
            )
        )
    }
}

// MARK: Private
private extension ProfileViewModel {
    func makeElements(profile: Driver<Profile>) -> Driver<[ProfileTableElement]> {
        profile.map { profile -> [ProfileTableElement] in
            [
                .avatar(profile.avatar),
                .name(profile.name),
                .size(profile.size),
                .gender(profile.gender),
                .height(profile.height),
                .occasions(profile.occasions),
                .seasons(profile.seasons)
            ]
        }
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
                ProfileMediator.shared.didUpdateSeasons.map { _ in Void() }
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
    
    func makeRoute(didSelect: Signal<ProfileTableElement>) -> Driver<Route> {
        didSelect
            .map { element -> Route in
                switch element {
                case .avatar:
                    return .changeAvatar
                case .name:
                    return .changeName
                case .size:
                    return .changeSize
                case .gender:
                    return .changeGender
                case .height:
                    return .changeHeight
                case .occasions:
                    return .changeOccasion
                case .seasons:
                    return .changeSeasons
                }
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeDisposable(
        didSelectNewAvatar: Signal<UIImage>,
        didDeleteAvatar: Signal<Void>
    ) -> Disposable {
        let newAvatar = didSelectNewAvatar
            .flatMapLatest { [weak self] image -> Driver<URL> in
                guard let self else { return .never() }
                
                return discoveryManager
                    .upload(image: image)
                    .compactMap { $0.url }
                    .asDriver(onErrorDriveWith: .never())
            }
            .flatMapLatest { [weak self] url -> Driver<Void> in
                guard let self else { return .never() }
                
                return profileManager
                    .update(avatar: url)
                    .asDriver(onErrorDriveWith: .never())
            }
            .drive()
        
        let deleteAvatar = didDeleteAvatar
            .flatMapLatest { [weak self] void -> Driver<Void> in
                guard let self else { return .never() }
                
                return profileManager
                    .update(avatar: nil)
                    .asDriver(onErrorDriveWith: .never())
            }
            .drive()
        
        return Disposables.create([newAvatar, deleteAvatar])
    }
}
