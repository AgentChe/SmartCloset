//
//  SIFilterViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 01.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SIFilterViewController: UIViewController {
    struct Data {
        let category: ItemCategory?
        let type: ItemType?
        let color: Color?
        let material: Material?
    }
    
    typealias Result = (Data) -> Void
    
    private lazy var mainView = SIFilterView()
    
    private let viewModel: SIFilterViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didSelectCategory = PublishRelay<ItemCategory?>()
    private lazy var didSelectType = PublishRelay<ItemType?>()
    private lazy var didSelectColor = PublishRelay<Color?>()
    private lazy var didSelectMaterial = PublishRelay<Material?>()
    
    private let result: Result
    
    private init(
        category: ItemCategory?,
        type: ItemType?,
        color: Color?,
        material: Material?,
        result: @escaping Result
    ) {
        self.viewModel = SIFilterViewModel(
            category: category,
            type: type,
            color: color,
            material: material
        )
        self.result = result
        
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
        
        let output = viewModel.configure(input: SIFilterViewModel.Input(
            didTapClose: mainView.closeButton.rx.tap.asSignal(),
            didSelectCategory: didSelectCategory.asSignal(),
            didSelectType: didSelectType.asSignal(),
            didSelectColor: didSelectColor.asSignal(),
            didSelectMaterial: didSelectMaterial.asSignal(),
            didSelectElement: mainView.tableView.didSelect,
            didTapApply: mainView.applyButton.rx.tap.asSignal()
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension SIFilterViewController {
    static func make(
        category: ItemCategory?,
        type: ItemType?,
        color: Color?,
        material: Material?,
        result: @escaping Result
    ) -> SIFilterViewController {
        let vc = SIFilterViewController(
            category: category,
            type: type,
            color: color,
            material: material,
            result: result
        )
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension SIFilterViewController {
    func route(_ route: SIFilterViewModel.Route) {
        switch route {
        case .dismiss:
            dismiss(animated: true)
        case .selectCategory:
            let vc = SICViewController.make { [weak self] category, type in
                self?.didSelectCategory.accept(category)
                self?.didSelectType.accept(type)
            }
            
            let nc = NavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            
            present(nc, animated: true)
        case .selectType(let category, let type):
            let vc = SITViewController.make(itemCategory: category, itemType: type) { [weak self] _, type in
                self?.didSelectType.accept(type)
            }
            
            let nc = NavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            
            present(nc, animated: true)
        case .selectColor(let color):
            let vc = SCViewController.make(color: color) { [weak self] color in
                self?.didSelectColor.accept(color)
            }
            
            let nc = NavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            
            present(nc, animated: true)
        case .selectMaterial(let material):
            let vc = SMViewController.make(material: material) { [weak self] material in
                self?.didSelectMaterial.accept(material)
            }
            
            let nc = NavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            
            present(nc, animated: true)
        case .result(let data):
            dismiss(animated: true) { [weak self] in
                self?.result(data)
            }
        }
    }
}
