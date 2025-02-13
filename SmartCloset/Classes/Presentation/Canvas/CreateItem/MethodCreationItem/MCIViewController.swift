//
//  MCIViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 11.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class MCIViewController: UIViewController {
    private lazy var mainView = MCIView()
    
    private lazy var viewModel = MCIViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var closeButton = TapAreaButton()
    
    private var choosePhoto: ChoosePhotoFromGallery?
    private var takePhoto: TakePhoto?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCloseButton()
        
        let didSelectMethod = Signal<MethodCreationItem>
            .merge(
                mainView.databaseButton.rx.tap
                    .map { MethodCreationItem.database }
                    .asSignal(onErrorSignalWith: .never()),
                mainView.galleryButton.rx.tap
                    .map { MethodCreationItem.gallery }
                    .asSignal(onErrorSignalWith: .never()),
                mainView.takePhotoButton.rx.tap
                    .map { MethodCreationItem.takePhoto }
                    .asSignal(onErrorSignalWith: .never())
            )
        
        let output = viewModel.configure(input: MCIViewModel.Input(
            didTapClose: closeButton.rx.tap.asSignal(),
            didSelectMethod: didSelectMethod
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension MCIViewController {
    static func make() -> NavigationController {
        let vc = MCIViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "MethodCreationItem.Title".localized
        
        let nc = NavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        
        return nc
    }
}

// MARK: Private
private extension MCIViewController {
    func route(_ route: MCIViewModel.Route) {
        switch route {
        case .close:
            navigationController?.dismiss(animated: true)
        case .database:
            let vc = AddItemToWardrobeViewController.make()
            navigationController?.setViewControllers([vc], animated: true)
        case .gallery:
            choosePhoto = ChoosePhotoFromGallery { [weak self] image in
                self?.choosePhoto = nil
                
                let inputData = CreateItemViewController.Image(image: image, source: .gallery)
                let vc = CreateItemViewController.make(image: inputData)
                self?.navigationController?.setViewControllers([vc], animated: true)
            }
            choosePhoto?.choose(from: self)
        case .takePhoto:
            takePhoto = TakePhoto { [weak self] image in
                self?.takePhoto = nil
                
                let inputData = CreateItemViewController.Image(image: image, source: .takePhoto)
                let vc = CreateItemViewController.make(image: inputData)
                self?.navigationController?.setViewControllers([vc], animated: true)
            }
            takePhoto?.take(from: self)
        }
    }
    
    func addCloseButton() {
        closeButton.backgroundColor = UIColor.clear
        closeButton.setImage(UIImage(named: "Close.Black"), for: .normal)
        
        let item = UIBarButtonItem(customView: closeButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 44.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 44.scale).isActive = true
        
        navigationItem.leftBarButtonItem = item
    }
}
