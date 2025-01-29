//
//  ProfileViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewController: UIViewController {
    private lazy var mainView = ProfileView()
    
    private lazy var viewModel = ProfileViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var takePhoto = TakePhoto { [weak self] image in
        self?.didSelectAvatarTrigger.accept(image)
    }
    private lazy var choosePhotoFromGallery = ChoosePhotoFromGallery { [weak self] image in
        self?.didSelectAvatarTrigger.accept(image)
    }
    
    private lazy var didSelectAvatarTrigger = PublishRelay<UIImage>()
    private lazy var didDeleteAvatarTrigger = PublishRelay<Void>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: ProfileViewModel.Input(
            didSelect: mainView.tableView.didSelect,
            didSelectNewAvatar: didSelectAvatarTrigger.asSignal(),
            didDeleteAvatar: didDeleteAvatarTrigger.asSignal()
        ))
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.disposable
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension ProfileViewController {
    static func make() -> ProfileViewController {
        let vc = ProfileViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "Profile.Title".localized
        return vc
    }
}

// MARK: Private
private extension ProfileViewController {
    func route(_ route: ProfileViewModel.Route) {
        switch route {
        case .changeAvatar:
            let vc = AvatarActionSheetController.make { [weak self] action in
                self?.handle(avatarAction: action)
            }
            present(vc, animated: true)
        case .changeName:
            print("___ changeName")
            break // TODO
        case .changeSize:
            print("___ changeSize")
            break // TODO
        case .changeGender:
            print("___ changeGender")
            break // TODO
        case .changeHeight:
            print("___ changeHeight")
            break // TODO
        case .changeOccasion:
            print("___ changeOccasion")
            break // TODO
        case .changeSeasons:
            print("___ changeSeasons")
            break // TODO
        }
    }
    
    private func handle(avatarAction: AvatarActionSheetController.Action) {
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
