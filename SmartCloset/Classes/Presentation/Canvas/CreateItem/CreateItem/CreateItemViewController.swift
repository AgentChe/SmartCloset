//
//  CreateItemViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 11.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateItemViewController: UIViewController {
    struct Image {
        enum Source {
            case gallery
            case takePhoto
        }
        
        let image: UIImage
        let source: Source
    }
    
    private lazy var mainView = CreateItemView()
    
    private let viewModel: CreateItemViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var closeButton = TapAreaButton()
    
    private lazy var newImageTrigger = PublishRelay<UIImage>()
    private lazy var didSelectCategoryTrigger = PublishRelay<ItemCategory?>()
    private lazy var didSelectTypeTrigger = PublishRelay<ItemType?>()
    private lazy var didSelectColorTrigger = PublishRelay<Color?>()
    private lazy var didSelectMaterialTrigger = PublishRelay<Material?>()
    
    private var choosePhotoFromGallery: ChoosePhotoFromGallery?
    private var takePhoto: TakePhoto?
    
    private init(image: Image) {
        self.viewModel = CreateItemViewModel(image: image)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCloseButton()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else { return .never() }
            return open(error: error)
        }
        
        let output = viewModel.configure(input: CreateItemViewModel.Input(
            didTapClose: closeButton.rx.tap.asSignal(),
            didTapChangePhoto: mainView.changePhotoButton.rx.tap.asSignal(),
            newImage: newImageTrigger.asSignal(),
            didTapCategory: mainView.tableView.didTapCategory,
            didTapType: mainView.tableView.didTapType,
            didTapColor: mainView.tableView.didTapColor,
            didTapMaterial: mainView.tableView.didTapMaterial,
            didInputName: mainView.tableView.didInputName,
            didSelectCategory: didSelectCategoryTrigger.asSignal(),
            didSelectType: didSelectTypeTrigger.asSignal(),
            didSelectColor: didSelectColorTrigger.asSignal(),
            didSelectMaterial: didSelectMaterialTrigger.asSignal(),
            didInputComment: mainView.tableView.didInputComment,
            didTapSave: mainView.saveButton.rx.tap.asSignal()
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route: route)
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.canSave
            .drive(Binder(mainView) { base, canSave in
                base.canSave(canSave)
            })
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(mainView) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension CreateItemViewController {
    static func make(image: CreateItemViewController.Image) -> CreateItemViewController {
        let vc = CreateItemViewController(image: image)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "CreateItem.Title".localized
        return vc
    }
}

// MARK: Private
private extension CreateItemViewController {
    func route(route: CreateItemViewModel.Route) {
        switch route {
        case .close:
            navigationController?.dismiss(animated: true)
        case .selectCategory:
            let vc = SICViewController.make { [weak self] category, type in
                self?.didSelectCategoryTrigger.accept(category)
                self?.didSelectTypeTrigger.accept(type)
            }
            
            let nc = NavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            
            present(nc, animated: true)
        case .selectType(let category, let type):
            let vc = SITViewController.make(itemCategory: category, itemType: type) { [weak self] _, type in
                self?.didSelectTypeTrigger.accept(type)
            }
            
            let nc = NavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            
            present(nc, animated: true)
        case .selectColor(let color):
            let vc = SCViewController.make(color: color) { [weak self] color in
                self?.didSelectColorTrigger.accept(color)
            }
            
            let nc = NavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            
            present(nc, animated: true)
        case .selectMaterial(let material):
            let vc = SMViewController.make(material: material) { [weak self] material in
                self?.didSelectMaterialTrigger.accept(material)
            }
            
            let nc = NavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            
            present(nc, animated: true)
        case .selectPhotoFromGallery:
            choosePhotoFromGallery = ChoosePhotoFromGallery { [weak self] image in
                self?.newImageTrigger.accept(image)
                self?.choosePhotoFromGallery = nil
            }
            choosePhotoFromGallery?.choose(from: self)
        case .takePhoto:
            takePhoto = TakePhoto { [weak self] image in
                self?.newImageTrigger.accept(image)
                self?.takePhoto = nil
            }
            takePhoto?.take(from: self)
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
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
    
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make(error: error) {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}
