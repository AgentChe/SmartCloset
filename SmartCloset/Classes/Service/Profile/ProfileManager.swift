//
//  ProfileManager.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 06.09.2024.
//

import RxSwift
import RxCocoa

protocol ProfileManagerProtocol: AnyObject {
    func create() -> Single<Void>
    func binding() -> Single<Void>
    func setup(profile: Profile) -> Single<Void>
    func update(name: String) -> Single<Void>
    func update(avatar: URL?) -> Single<Void>
    func update(size: Size) -> Single<Void>
    func update(gender: Gender) -> Single<Void>
    func update(height: Height) -> Single<Void>
    func update(interestedColors: [String]) -> Single<Void>
    func update(occasions: [Occasion]) -> Single<Void>
    func update(seasons: [Season]) -> Single<Void>
    func obtainProfile(forceUpdate: Bool) -> Single<Profile?>
}

final class ProfileManager {
    private lazy var restApiTransport = RestAPITransport()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: ProfileManagerProtocol
extension ProfileManager: ProfileManagerProtocol {
    func create() -> Single<Void> {
        let request = ProfileCreateRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func binding() -> Single<Void> {
        let request = ProfileBindingRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func setup(profile: Profile) -> Single<Void> {
        let request = SetProfileRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            name: profile.name,
            avatar: profile.avatar?.absoluteString,
            size: profile.size?.rawCode,
            gender: profile.gender?.rawCode,
            heightValue: profile.height?.value,
            heightUnit: profile.height?.unit.rawCode,
            interestedColors: profile.interestedColors,
            occasions: profile.occasions?.map { $0.rawCode },
            seasons: profile.seasons?.map { $0.rawCode }
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .mapToVoid()
            .do(onSuccess: { [weak self] in
                self?.store(profile: profile, notify: true)
            })
    }
    
    func update(name: String) -> Single<Void> {
        cachedProfile()
            .flatMap { [weak self] profile -> Single<Void> in
                guard let self else { return .never() }
                
                let request = SetProfileRequest(
                    anonymousId: sessionManager.anonymousId,
                    internalId: sessionManager.internalId,
                    name: name,
                    avatar: profile.avatar?.absoluteString,
                    size: profile.size?.rawCode,
                    gender: profile.gender?.rawCode,
                    heightValue: profile.height?.value,
                    heightUnit: profile.height?.unit.rawCode,
                    interestedColors: profile.interestedColors,
                    occasions: profile.occasions?.map { $0.rawCode },
                    seasons: profile.seasons?.map { $0.rawCode }
                )
                
                return restApiTransport
                    .callServerApi(requestBody: request)
                    .mapToVoid()
                    .do(onSuccess: { [weak self] in
                        self?.store(name: name)
                    })
            }
    }
    
    func update(avatar: URL?) -> Single<Void> {
        cachedProfile()
            .flatMap { [weak self] profile -> Single<Void> in
                guard let self else { return .never() }
                
                let request = SetProfileRequest(
                    anonymousId: sessionManager.anonymousId,
                    internalId: sessionManager.internalId,
                    name: profile.name,
                    avatar: avatar?.absoluteString,
                    size: profile.size?.rawCode,
                    gender: profile.gender?.rawCode,
                    heightValue: profile.height?.value,
                    heightUnit: profile.height?.unit.rawCode,
                    interestedColors: profile.interestedColors,
                    occasions: profile.occasions?.map { $0.rawCode },
                    seasons: profile.seasons?.map { $0.rawCode }
                )
                
                return restApiTransport
                    .callServerApi(requestBody: request)
                    .mapToVoid()
                    .do(onSuccess: { [weak self] in
                        self?.store(avatar: avatar)
                    })
            }
    }
    
    func update(size: Size) -> Single<Void> {
        cachedProfile()
            .flatMap { [weak self] profile -> Single<Void> in
                guard let self else { return .never() }
                
                let request = SetProfileRequest(
                    anonymousId: sessionManager.anonymousId,
                    internalId: sessionManager.internalId,
                    name: profile.name,
                    avatar: profile.avatar?.absoluteString,
                    size: size.rawCode,
                    gender: profile.gender?.rawCode,
                    heightValue: profile.height?.value,
                    heightUnit: profile.height?.unit.rawCode,
                    interestedColors: profile.interestedColors,
                    occasions: profile.occasions?.map { $0.rawCode },
                    seasons: profile.seasons?.map { $0.rawCode }
                )
                
                return restApiTransport
                    .callServerApi(requestBody: request)
                    .mapToVoid()
                    .do(onSuccess: { [weak self] in
                        self?.store(size: size)
                    })
            }
    }
    
    func update(gender: Gender) -> Single<Void> {
        cachedProfile()
            .flatMap { [weak self] profile -> Single<Void> in
                guard let self else { return .never() }
                
                let request = SetProfileRequest(
                    anonymousId: sessionManager.anonymousId,
                    internalId: sessionManager.internalId,
                    name: profile.name,
                    avatar: profile.avatar?.absoluteString,
                    size: profile.size?.rawCode,
                    gender: gender.rawCode,
                    heightValue: profile.height?.value,
                    heightUnit: profile.height?.unit.rawCode,
                    interestedColors: profile.interestedColors,
                    occasions: profile.occasions?.map { $0.rawCode },
                    seasons: profile.seasons?.map { $0.rawCode }
                )
                
                return restApiTransport
                    .callServerApi(requestBody: request)
                    .mapToVoid()
                    .do(onSuccess: { [weak self] in
                        self?.store(gender: gender)
                    })
            }
    }
    
    func update(height: Height) -> Single<Void> {
        cachedProfile()
            .flatMap { [weak self] profile -> Single<Void> in
                guard let self else { return .never() }
                
                let request = SetProfileRequest(
                    anonymousId: sessionManager.anonymousId,
                    internalId: sessionManager.internalId,
                    name: profile.name,
                    avatar: profile.avatar?.absoluteString,
                    size: profile.size?.rawCode,
                    gender: profile.gender?.rawCode,
                    heightValue: height.value,
                    heightUnit: height.unit.rawCode,
                    interestedColors: profile.interestedColors,
                    occasions: profile.occasions?.map { $0.rawCode },
                    seasons: profile.seasons?.map { $0.rawCode }
                )
                
                return restApiTransport
                    .callServerApi(requestBody: request)
                    .mapToVoid()
                    .do(onSuccess: { [weak self] in
                        self?.store(height: height)
                    })
            }
    }
    
    func update(interestedColors: [String]) -> Single<Void> {
        cachedProfile()
            .flatMap { [weak self] profile -> Single<Void> in
                guard let self else { return .never() }
                
                let request = SetProfileRequest(
                    anonymousId: sessionManager.anonymousId,
                    internalId: sessionManager.internalId,
                    name: profile.name,
                    avatar: profile.avatar?.absoluteString,
                    size: profile.size?.rawCode,
                    gender: profile.gender?.rawCode,
                    heightValue: profile.height?.value,
                    heightUnit: profile.height?.unit.rawCode,
                    interestedColors: interestedColors,
                    occasions: profile.occasions?.map { $0.rawCode },
                    seasons: profile.seasons?.map { $0.rawCode }
                )
                
                return restApiTransport
                    .callServerApi(requestBody: request)
                    .mapToVoid()
                    .do(onSuccess: { [weak self] in
                        self?.store(interestedColors: interestedColors)
                    })
            }
    }
    
    func update(occasions: [Occasion]) -> Single<Void> {
        cachedProfile()
            .flatMap { [weak self] profile -> Single<Void> in
                guard let self else { return .never() }
                
                let request = SetProfileRequest(
                    anonymousId: sessionManager.anonymousId,
                    internalId: sessionManager.internalId,
                    name: profile.name,
                    avatar: profile.avatar?.absoluteString,
                    size: profile.size?.rawCode,
                    gender: profile.gender?.rawCode,
                    heightValue: profile.height?.value,
                    heightUnit: profile.height?.unit.rawCode,
                    interestedColors: profile.interestedColors,
                    occasions: occasions.map { $0.rawCode },
                    seasons: profile.seasons?.map { $0.rawCode }
                )
                
                return restApiTransport
                    .callServerApi(requestBody: request)
                    .mapToVoid()
                    .do(onSuccess: { [weak self] in
                        self?.store(occasions: occasions)
                    })
            }
    }
    
    func update(seasons: [Season]) -> Single<Void> {
        cachedProfile()
            .flatMap { [weak self] profile -> Single<Void> in
                guard let self else { return .never() }
                
                let request = SetProfileRequest(
                    anonymousId: sessionManager.anonymousId,
                    internalId: sessionManager.internalId,
                    name: profile.name,
                    avatar: profile.avatar?.absoluteString,
                    size: profile.size?.rawCode,
                    gender: profile.gender?.rawCode,
                    heightValue: profile.height?.value,
                    heightUnit: profile.height?.unit.rawCode,
                    interestedColors: profile.interestedColors,
                    occasions: profile.occasions?.map { $0.rawCode },
                    seasons: seasons.map { $0.rawCode }
                )
                
                return restApiTransport
                    .callServerApi(requestBody: request)
                    .mapToVoid()
                    .do(onSuccess: { [weak self] in
                        self?.store(seasons: seasons)
                    })
            }
    }
    
    func obtainProfile(forceUpdate: Bool) -> Single<Profile?> {
        forceUpdate ? loadProfile() : cachedProfile().map { profile -> Profile? in profile }
    }
}

// MARK: Private
private extension ProfileManager {
    enum Constants {
        static let nameKey = "pm_name"
        static let avatarKey = "pm_avatar"
        static let sizeKey = "pm_size"
        static let genderKey = "pm_gender"
        static let heightKey = "pm_height"
        static let interestedColorsKey = "pm_interestedColors"
        static let occasionsKey = "pm_occasions"
        static let seasonsKey = "pm_seasons"
    }
    
    func store(profile: Profile, notify: Bool) {
        let nameData: Data? = {
            guard let name = profile.name else { return nil }
            return try? JSONEncoder().encode(name)
        }()
        let avatarData: Data? = {
            guard let avatar = profile.avatar else { return nil }
            return try? JSONEncoder().encode(avatar)
        }()
        let sizeData: Data? = {
            guard let size = profile.size else { return nil }
            return try? JSONEncoder().encode(size)
        }()
        let genderData: Data? = {
            guard let gender = profile.gender else { return nil }
            return try? JSONEncoder().encode(gender)
        }()
        let heightData: Data? = {
            guard let height = profile.height else { return nil }
            return try? JSONEncoder().encode(height)
        }()
        let interestedColorsData: Data? = {
            guard let interestedColors = profile.interestedColors else { return nil }
            return try? JSONEncoder().encode(interestedColors)
        }()
        let occasionsData: Data? = {
            guard let occasions = profile.occasions else { return nil }
            return try? JSONEncoder().encode(occasions)
        }()
        let seasonsData: Data? = {
            guard let seasons = profile.seasons else { return nil }
            return try? JSONEncoder().encode(seasons)
        }()
        
        UserDefaults.standard.set(nameData, forKey: Constants.nameKey)
        UserDefaults.standard.set(avatarData, forKey: Constants.avatarKey)
        UserDefaults.standard.set(sizeData, forKey: Constants.sizeKey)
        UserDefaults.standard.set(genderData, forKey: Constants.genderKey)
        UserDefaults.standard.set(heightData, forKey: Constants.heightKey)
        UserDefaults.standard.set(interestedColorsData, forKey: Constants.interestedColorsKey)
        UserDefaults.standard.set(occasionsData, forKey: Constants.occasionsKey)
        UserDefaults.standard.set(seasonsData, forKey: Constants.seasonsKey)
        
        ProfileMediator.shared.update(profile: profile)
    }
    
    func store(name: String?) {
        let data: Data? = {
            guard let name else { return nil }
            return try? JSONEncoder().encode(name)
        }()
        
        UserDefaults.standard.set(data, forKey: Constants.nameKey)
        
        ProfileMediator.shared.update(name: name)
    }
    
    func store(avatar: URL?) {
        let data: Data? = {
            guard let avatar else { return nil }
            return try? JSONEncoder().encode(avatar)
        }()
        
        UserDefaults.standard.set(data, forKey: Constants.avatarKey)
        
        ProfileMediator.shared.update(avatar: avatar)
    }
    
    func store(size: Size?) {
        let data: Data? = {
            guard let size else { return nil }
            return try? JSONEncoder().encode(size)
        }()
        
        UserDefaults.standard.set(data, forKey: Constants.sizeKey)
        
        ProfileMediator.shared.update(size: size)
    }
    
    func store(gender: Gender?) {
        let data: Data? = {
            guard let gender else { return nil }
            return try? JSONEncoder().encode(gender)
        }()
        
        UserDefaults.standard.set(data, forKey: Constants.genderKey)
        
        ProfileMediator.shared.update(gender: gender)
    }
    
    func store(height: Height?) {
        let data: Data? = {
            guard let height else { return nil }
            return try? JSONEncoder().encode(height)
        }()
        
        UserDefaults.standard.set(data, forKey: Constants.heightKey)
        
        ProfileMediator.shared.update(height: height)
    }
    
    func store(interestedColors: [String]?) {
        let data: Data? = {
            guard let interestedColors else { return nil }
            return try? JSONEncoder().encode(interestedColors)
        }()
        
        UserDefaults.standard.set(data, forKey: Constants.interestedColorsKey)
        
        ProfileMediator.shared.update(interestedColors: interestedColors)
    }
    
    func store(occasions: [Occasion]?) {
        let data: Data? = {
            guard let occasions else { return nil }
            return try? JSONEncoder().encode(occasions)
        }()
        
        UserDefaults.standard.set(data, forKey: Constants.occasionsKey)
        
        ProfileMediator.shared.update(occasions: occasions)
    }
    
    func store(seasons: [Season]?) {
        let data: Data? = {
            guard let seasons else { return nil }
            return try? JSONEncoder().encode(seasons)
        }()
        
        UserDefaults.standard.set(data, forKey: Constants.seasonsKey)
        
        ProfileMediator.shared.update(seasons: seasons)
    }
    
    func loadProfile() -> Single<Profile?> {
        let request = ObtainProfileRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { Profile(response: $0) }
            .do(onSuccess: { [weak self] profile in
                guard let profile else { return }
                
                self?.store(profile: profile, notify: false)
            })
    }
    
    func cachedProfile() -> Single<Profile> {
        Single<Profile>.create { single in
            let name: String? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.nameKey) else { return nil }
                return try? JSONDecoder().decode(String.self, from: data)
            }()
            
            let avatar: URL? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.avatarKey) else { return nil }
                return try? JSONDecoder().decode(URL.self, from: data)
            }()
            
            let size: Size? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.sizeKey) else { return nil }
                return try? JSONDecoder().decode(Size.self, from: data)
            }()
            
            let gender: Gender? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.genderKey) else { return nil }
                return try? JSONDecoder().decode(Gender.self, from: data)
            }()
            
            let height: Height? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.heightKey) else { return nil }
                return try? JSONDecoder().decode(Height.self, from: data)
            }()
            
            let interestedColors: [String]? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.interestedColorsKey) else { return nil }
                return try? JSONDecoder().decode([String].self, from: data)
            }()
            
            let occasions: [Occasion]? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.occasionsKey) else { return nil }
                return try? JSONDecoder().decode([Occasion].self, from: data)
            }()
            
            let seasons: [Season]? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.seasonsKey) else { return nil }
                return try? JSONDecoder().decode([Season].self, from: data)
            }()
            
            let profile = Profile(
                name: name,
                avatar: avatar,
                size: size,
                gender: gender,
                height: height,
                interestedColors: interestedColors,
                occasions: occasions,
                seasons: seasons
            )
            
            single(.success(profile))
            
            return Disposables.create()
        }
    }
}
