//
//  InspirationViewModel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import RxSwift
import RxCocoa

final class InspirationViewModel {
    enum Route {
        case settings
        case search
        case openItemCategory(ItemCategory)
        case openItem(Item)
        case openLook(Look)
        case openRecommendations
    }
    
    private lazy var profileManager = ProfileManager()
    private lazy var collectionsManager = CollectionsManager()
}

// MARK: Public
extension InspirationViewModel {
    struct Input {
        let didTapSettings: Signal<Void>
        let didTapSearch: Signal<Void>
        let didSelectItemCategory: Signal<ItemCategory>
        let didSelectItem: Signal<Item>
        let didSelectLook: Signal<Look>
        let didTapSeeAllRecommendations: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
        let headerData: Driver<InspirationHeaderView.Data>
        let elements: Driver<[InspirationTableElement]>
    }
    
    func configure(input: Input) -> Output {
        let profile = makeProfile()
        let recommendations = makeRecommendations()
        
        return Output(
            route: makeRoute(
                didTapSettings: input.didTapSettings,
                didTapSearch: input.didTapSearch,
                didSelectItemCategory: input.didSelectItemCategory,
                didSelectItem: input.didSelectItem,
                didSelectLook: input.didSelectLook,
                didTapSeeAllRecommendations: input.didTapSeeAllRecommendations
            ),
            headerData: makeHeaderData(profile: profile),
            elements: makeElements(
                profile: profile,
                recommendations: recommendations
            )
        )
    }
}

// MARK: Private
private extension InspirationViewModel {
    func makeRoute(
        didTapSettings: Signal<Void>,
        didTapSearch: Signal<Void>,
        didSelectItemCategory: Signal<ItemCategory>,
        didSelectItem: Signal<Item>,
        didSelectLook: Signal<Look>,
        didTapSeeAllRecommendations: Signal<Void>
    ) -> Driver<Route> {
        let settings = didTapSettings
            .map { Route.settings }
            .asDriver(onErrorDriveWith: .never())
        
        let search = didTapSearch
            .map { Route.search }
            .asDriver(onErrorDriveWith: .never())
        
        let openItemCategory = didSelectItemCategory
            .map { Route.openItemCategory($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let openItem = didSelectItem
            .map { Route.openItem($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let openLook = didSelectLook
            .map { Route.openLook($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let openRecommendations = didTapSeeAllRecommendations
            .map { Route.openRecommendations }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(settings, search, openItemCategory, openItem, openLook, openRecommendations)
    }
    
    func makeHeaderData(profile: Driver<Profile>) -> Driver<InspirationHeaderView.Data> {
        profile.map { profile -> InspirationHeaderView.Data in
            InspirationHeaderView.Data(
                season: profile.season,
                name: profile.name
            )
        }
    }
    
    func makeElements(
        profile: Driver<Profile>,
        recommendations: Driver<Recommendations?>
    ) -> Driver<[InspirationTableElement]> {
        Driver
            .combineLatest(profile, recommendations)
            .map { profile, recommendations -> [InspirationTableElement] in
                var result = [InspirationTableElement]()
                
                if let recommendations, let elements = InspirationTableRecommendationsElement.array(recommendations: recommendations) {
                    result.append(.recommendations(elements))
                }
                
                let itemCategories = ItemCategory.allCases
                result.append(.itemCategories(itemCategories))
                
                if let gender = profile.gender, let season = profile.season {
                    var itemCategories = ItemCategory.allCases.shuffled()
                    let leftItemCategory = itemCategories.removeFirst()
                    let rightItemCategory = itemCategories.removeFirst()
                    
                    let collectionsElement = InspirationTableCollectionElement(
                        leftItemCategory: leftItemCategory,
                        rightItemCategory: rightItemCategory,
                        gender: gender,
                        season: season
                    )
                    
                    result.append(.collections(collectionsElement))
                }
                
                return result
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
    
    func makeRecommendations() -> Driver<Recommendations?> {
        collectionsManager
            .obtainRecommendations(page: 1, limit: 20)
            .map { $0?.elements }
            .asDriver(onErrorJustReturn: nil)
    }
}
