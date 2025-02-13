//
//  CanvasViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 06.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CanvasViewController: UIViewController {
    private lazy var mainView = CanvasView()
    
    private lazy var viewModel = CanvasViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let openWardrobe: () -> Void
    
    private init(openWardrobe: @escaping () -> Void) {
        self.openWardrobe = openWardrobe
        
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
        
        let didTapItemCategory = Signal<ItemCategory>
            .merge(
                mainView.topsButton.didTap,
                mainView.bottomsButton.didTap,
                mainView.shoesButton.didTap,
                mainView.bagsButton.didTap,
                mainView.accessoriesButton.didTap
            )
        
        let output = viewModel.configure(input: CanvasViewModel.Input(
            didTapItemCategory: didTapItemCategory
        ))
        
        output.season
            .drive(Binder(mainView.headerView) { base, season in
                base.setup(season: season)
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension CanvasViewController {
    static func make(openWardrobe: @escaping () -> Void) -> CanvasViewController {
        let vc = CanvasViewController(openWardrobe: openWardrobe)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension CanvasViewController {
    func route(_ route: CanvasViewModel.Route) {
        switch route {
        case .createLook(let itemCategory):
            CreateLookAssembly().create(from: self, itemCategory: itemCategory, openWardrobe: openWardrobe)
        }
    }
}
