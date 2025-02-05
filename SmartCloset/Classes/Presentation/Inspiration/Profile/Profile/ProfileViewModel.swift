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
        case changeName(String?)
        case changeSize(Size?)
        case changeGender(Gender?)
        case changeHeight(Height?)
        case changeOccasions([Occasion]?)
        case changeSeason(Season?)
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
            route: makeRoute(
                didSelect: input.didSelect,
                profile: profile
            ),
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
                .season(profile.season)
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
    
    func makeRoute(
        didSelect: Signal<ProfileTableElement>,
        profile: Driver<Profile>
    ) -> Driver<Route> {
        didSelect
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(profile) { ($0, $1) }
            .map { args -> Route in
                let (element, profile) = args
                
                switch element {
                case .avatar:
                    return .changeAvatar
                case .name:
                    return .changeName(profile.name)
                case .size:
                    return .changeSize(profile.size)
                case .gender:
                    return .changeGender(profile.gender)
                case .height:
                    return .changeHeight(profile.height)
                case .occasions:
                    return .changeOccasions(profile.occasions)
                case .season:
                    return .changeSeason(profile.season)
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
}
