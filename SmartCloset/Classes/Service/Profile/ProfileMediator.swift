//
//  ProfileMediator.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 25.01.2025.
//

import RxSwift
import RxCocoa

final class ProfileMediator {
    static let shared = ProfileMediator()
    
    private init() {}
    
    private lazy var didUpdateProfileTrigger = PublishRelay<Profile>()
    private lazy var didUpdateNameTrigger = PublishRelay<String?>()
    private lazy var didUpdateAvatarTrigger = PublishRelay<URL?>()
    private lazy var didUpdateSizeTrigger = PublishRelay<Size?>()
    private lazy var didUpdateGenderTrigger = PublishRelay<Gender?>()
    private lazy var didUpdateHeightTrigger = PublishRelay<Height?>()
    private lazy var didUpdateInterestedColorsTrigger = PublishRelay<[String]?>()
    private lazy var didUpdateOccasionsTrigger = PublishRelay<[Occasion]?>()
    private lazy var didUpdateSeasonTrigger = PublishRelay<Season?>()
}

// MARK: Public
extension ProfileMediator {
    func update(profile: Profile) {
        didUpdateProfileTrigger.accept(profile)
    }
    
    func update(name: String?) {
        didUpdateNameTrigger.accept(name)
    }
    
    func update(avatar: URL?) {
        didUpdateAvatarTrigger.accept(avatar)
    }
    
    func update(size: Size?) {
        didUpdateSizeTrigger.accept(size)
    }
    
    func update(gender: Gender?) {
        didUpdateGenderTrigger.accept(gender)
    }
    
    func update(height: Height?) {
        didUpdateHeightTrigger.accept(height)
    }
    
    func update(interestedColors: [String]?) {
        didUpdateInterestedColorsTrigger.accept(interestedColors)
    }
    
    func update(occasions: [Occasion]?) {
        didUpdateOccasionsTrigger.accept(occasions)
    }
    
    func update(season: Season?) {
        didUpdateSeasonTrigger.accept(season)
    }
    
    var didUpdateProfile: Signal<Profile> {
        didUpdateProfileTrigger.asSignal()
    }
    
    var didUpdateName: Signal<String?> {
        didUpdateNameTrigger.asSignal()
    }
    
    var didUpdateAvatar: Signal<URL?> {
        didUpdateAvatarTrigger.asSignal()
    }
    
    var didUpdateSize: Signal<Size?> {
        didUpdateSizeTrigger.asSignal()
    }
    
    var didUpdateGender: Signal<Gender?> {
        didUpdateGenderTrigger.asSignal()
    }
    
    var didUpdateHeight: Signal<Height?> {
        didUpdateHeightTrigger.asSignal()
    }
    
    var didUpdateInterestedColors: Signal<[String]?> {
        didUpdateInterestedColorsTrigger.asSignal()
    }
    
    var didUpdateOccasions: Signal<[Occasion]?> {
        didUpdateOccasionsTrigger.asSignal()
    }
    
    var didUpdateSeason: Signal<Season?> {
        didUpdateSeasonTrigger.asSignal()
    }
}
