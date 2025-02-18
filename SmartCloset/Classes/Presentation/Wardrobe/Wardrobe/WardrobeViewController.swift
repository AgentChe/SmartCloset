//
//  WardrobeViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 15.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class WardrobeViewController: UIViewController {
    private lazy var mainView = WardrobeView()
    
    private lazy var viewModel = WardrobeViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var takePhoto = TakePhoto { [weak self] image in
        self?.didSelectAvatarTrigger.accept(image)
    }
    private lazy var choosePhotoFromGallery = ChoosePhotoFromGallery { [weak self] image in
        self?.didSelectAvatarTrigger.accept(image)
    }
    
    private lazy var coordinator = WardrobeCoordinator(parentVC: self, container: mainView.container, openCollection: { [weak self] collection in
        let vc = CollectionViewController.make(collection: collection)
        self?.navigationController?.pushViewController(vc, animated: true)
    }, createCollection: { [weak self] in
        guard let self else { return }
        
        CreateCollectionAssembly().create(from: self)
    }, collectionsContentEmpty: { [weak self] isEmpty in
        self?.collectionsContentEmptyTrigger.accept(isEmpty)
    }, openLook: { [weak self] look in
        let vc = LookViewController.make(look: look)
        self?.navigationController?.pushViewController(vc, animated: true)
    }, openFavoritesLooks: { [weak self] in
        let vc = LooksViewController.favorites()
        self?.navigationController?.pushViewController(vc, animated: true)
    }, openAllLooks: { [weak self] in
        let vc = LooksViewController.allCustom()
        self?.navigationController?.pushViewController(vc, animated: true)
    }, createLook: { [weak self] in
        guard let self else { return }
        
        CreateLookAssembly().create(from: self)
    }, looksContentEmpty: { [weak self] isEmpty in
        self?.looksContentEmptyTrigger.accept(isEmpty)
    })
    
    private lazy var didSelectAvatarTrigger = PublishRelay<UIImage>()
    private lazy var didDeleteAvatarTrigger = PublishRelay<Void>()
    private lazy var itemsContentEmptyTrigger = PublishRelay<Bool>() 
    private lazy var looksContentEmptyTrigger = PublishRelay<Bool>()
    private lazy var collectionsContentEmptyTrigger = PublishRelay<Bool>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: WardrobeViewModel.Input(
            didTapSettings: mainView.headerView.settingsButton.rx.tap.asSignal(),
            didTapSelectNewAvatar: mainView.headerView.imageActionButton.rx.tap.asSignal(),
            didSelectNewAvatar: didSelectAvatarTrigger.asSignal(),
            didDeleteAvatar: didDeleteAvatarTrigger.asSignal(),
            didSelectTab: mainView.tabsView.didSelect,
            didTapAdd: mainView.addTabSelectSheetView.addButton.rx.tap.asSignal(),
            didTapCreateItem: mainView.addTabSelectSheetView.itemButton.rx.tap.asSignal(),
            didTapCreateLook: mainView.addTabSelectSheetView.lookButton.rx.tap.asSignal(),
            didTapCreateCollection: mainView.addTabSelectSheetView.collectionButton.rx.tap.asSignal(),
            itemsContentEmpty: itemsContentEmptyTrigger.asSignal(),
            looksContentEmpty: looksContentEmptyTrigger.asSignal(),
            collectionsContentEmpty: collectionsContentEmptyTrigger.asSignal()
        ))
        
        let selectedTab = output.selectedTab
        
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .withLatestFrom(selectedTab)
            .bind(to: Binder(self) { base, tab in
                base.coordinator.change(tab: tab)
                base.mainView.tabsView.setup(tab: tab)
            })
            .disposed(by: disposeBag)
        
        selectedTab
            .skip(1)
            .drive(Binder(self) { base, tab in
                base.coordinator.change(tab: tab)
                base.mainView.tabsView.setup(tab: tab)
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.profile
            .drive(Binder(mainView.headerView) { base, profile in
                base.setup(profile: profile)
            })
            .disposed(by: disposeBag)
        
        output.disposable
            .disposed(by: disposeBag)
        
        output.addMode
            .drive(Binder(mainView) { base, mode in
                base.addTab(mode: mode)
            })
            .disposed(by: disposeBag)
        
        output.addObjectHidden
            .drive(mainView.addTabSelectSheetView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension WardrobeViewController {
    static func make() -> WardrobeViewController {
        let vc = WardrobeViewController()
        vc.navigationItem.title = " "
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension WardrobeViewController {
    func route(_ route: WardrobeViewModel.Route) {
        switch route {
        case .settings:
            let vc = SettingsViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .changeAvatar:
            let vc = AvatarActionSheetController.make { [weak self] action in
                self?.handle(avatarAction: action)
            }
            present(vc, animated: true)
        case .createItem:
            let vc = MCIViewController.make()
            present(vc, animated: true)
        case .createLook:
            CreateLookAssembly().create(from: self)
        case .createCollection:
            CreateCollectionAssembly().create(from: self)
        }
    }
    
    func handle(avatarAction: AvatarActionSheetController.Action) {
        switch avatarAction {
        case .takePhoto:
            takePhoto.take(from: self)
        case .chooseFromGallery:
            choosePhotoFromGallery.choose(from: self)
        case .delete:
            didDeleteAvatarTrigger.accept(Void())
        }
    }
}
