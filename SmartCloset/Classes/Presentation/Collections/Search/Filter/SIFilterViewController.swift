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
    private lazy var mainView = SIFilterView()
    
    private let viewModel: SIFilterViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didSelectCategory = PublishRelay<ItemCategory?>()
    private lazy var didSelectType = PublishRelay<ItemType?>()
    private lazy var didSelectColor = PublishRelay<Color?>()
    private lazy var didSelectMaterial = PublishRelay<Material?>()
    
    private init(
        category: ItemCategory?,
        type: ItemType?,
        color: Color?,
        material: Material?
    ) {
        viewModel = SIFilterViewModel(
            category: category,
            type: type,
            color: color,
            material: material
        )
        
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
            didSelectElement: mainView.tableView.didSelect
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
        material: Material?
    ) -> SIFilterViewController {
        let vc = SIFilterViewController(
            category: category,
            type: type,
            color: color,
            material: material
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
        case .selectCategory(let category):
            break // TODO
        case .selectType(let type):
            break // TODO
        case .selectColor(let color):
            break // TODO
        case .selectMaterial(let material):
            break // TODO
        }
    }
}
