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
        case createItem
        case createLook
        case createCollection
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
        let didTapAdd: Signal<Void>
        let didTapCreateItem: Signal<Void>
        let didTapCreateLook: Signal<Void>
        let didTapCreateCollection: Signal<Void>
        let itemsContentEmpty: Signal<Bool>
        let looksContentEmpty: Signal<Bool>
        let collectionsContentEmpty: Signal<Bool>
    }
    
    struct Output {
        let route: Driver<Route>
        let profile: Driver<Profile>
        let disposable: Disposable
        let selectedTab: Driver<WardrobeTabItemButton.Tab>
        let addMode: Driver<WardrobeAddTabSelectSheetView.Mode>
        let addObjectHidden: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let selectedTab = makeSelectedTab(didSelectTab: input.didSelectTab)
        
        return Output(
            route: makeRoute(
                didTapSettings: input.didTapSettings,
                didTapSelectNewAvatar: input.didTapSelectNewAvatar,
                didTapCreateItem: input.didTapCreateItem,
                didTapCreateLook: input.didTapCreateLook,
                didTapCreateCollection: input.didTapCreateCollection
            ),
            profile: makeProfile(),
            disposable: makeDisposable(
                didSelectNewAvatar: input.didSelectNewAvatar,
                didDeleteAvatar: input.didDeleteAvatar
            ),
            selectedTab: selectedTab,
            addMode: makeAddMode(
                didTapAdd: input.didTapAdd,
                didTapCreateItem: input.didTapCreateItem,
                didTapCreateLook: input.didTapCreateLook,
                didTapCreateCollection: input.didTapCreateCollection
            ),
            addObjectHidden: makeAddTabObjectHidden(
                selectedTab: selectedTab,
                itemsContentEmpty: input.itemsContentEmpty,
                looksContentEmpty: input.looksContentEmpty,
                collectionsContentEmpty: input.collectionsContentEmpty
            )
        )
    }
}

// MARK: Private
private extension WardrobeViewModel {
    func makeRoute(
        didTapSettings: Signal<Void>,
        didTapSelectNewAvatar: Signal<Void>,
        didTapCreateItem: Signal<Void>,
        didTapCreateLook: Signal<Void>,
        didTapCreateCollection: Signal<Void>
    ) -> Driver<Route> {
        let settings = didTapSettings
            .map { Route.settings }
            .asDriver(onErrorDriveWith: .never())
        
        let changeAvatar = didTapSelectNewAvatar
            .map { Route.changeAvatar }
            .asDriver(onErrorDriveWith: .never())
        
        let createTabObject = Signal<Route>
            .merge(
                didTapCreateItem.map { Route.createItem },
                didTapCreateLook.map { Route.createLook },
                didTapCreateCollection.map { Route.createCollection }
            )
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(settings, changeAvatar, createTabObject)
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
    
    func makeAddMode(
        didTapAdd: Signal<Void>,
        didTapCreateItem: Signal<Void>,
        didTapCreateLook: Signal<Void>,
        didTapCreateCollection: Signal<Void>
    ) -> Driver<WardrobeAddTabSelectSheetView.Mode> {
        let start = Signal<Void>
            .merge(
                didTapCreateItem,
                didTapCreateLook,
                didTapCreateCollection
            )
            .map { WardrobeAddTabSelectSheetView.Mode.off }
            .startWith(.off)
        
        return start
            .flatMapLatest { initial -> Driver<WardrobeAddTabSelectSheetView.Mode> in
                didTapAdd
                    .scan(initial) { current, void -> WardrobeAddTabSelectSheetView.Mode in
                        switch current {
                        case .on:
                            return .off
                        case .off:
                            return .on
                        }
                    }
                    .startWith(initial)
                    .asDriver(onErrorDriveWith: .never())
            }
    }
    
    func makeAddTabObjectHidden(
        selectedTab: Driver<WardrobeTabItemButton.Tab>,
        itemsContentEmpty: Signal<Bool>,
        looksContentEmpty: Signal<Bool>,
        collectionsContentEmpty: Signal<Bool>
    ) -> Driver<Bool> {
        let itemsEmpty = itemsContentEmpty
            .asDriver(onErrorDriveWith: .never())
            .startWith(false)
        let looksEmpty = looksContentEmpty
            .asDriver(onErrorDriveWith: .never())
            .startWith(false)
        let collectionsEmpty = collectionsContentEmpty
            .asDriver(onErrorDriveWith: .never())
            .startWith(false)
        
        return Driver
            .combineLatest(selectedTab, itemsEmpty, looksEmpty, collectionsEmpty)
            .map { tab, itemsEmpty, looksEmpty, collectionsEmpty -> Bool in
                switch tab {
                case .items:
                    return itemsEmpty
                case .looks:
                    return looksEmpty
                case .collections:
                    return collectionsEmpty
                }
            }
            .startWith(false)
    }
}
