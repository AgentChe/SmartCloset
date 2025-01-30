//
//  ChangeProfileViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 30.01.2025.
//

import UIKit
import RxSwift

final class ChangeProfileViewController: UIViewController {
    private let mainView: ChangeProfileFieldView
    
    private lazy var viewModel = ChangeProfileViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private init(field: Field) {
        mainView = {
            switch field {
            case .name(let name):
                let view = ChangeNameView()
                view.setup(name: name)
                return view
            case .size(let size):
                let view = ChangeSizeView()
                view.setup(size: size)
                return view
            case .gender(let gender):
                let view = ChangeGenderView()
                view.setup(gender: gender)
                return view
            case .height(let height):
                let view = ChangeHeightView()
                view.setup(height: height)
                return view
            case .occasions(let occasions):
                let view = ChangeOccasionsView()
                view.setup(occasions: occasions)
                return view
            case .seasons(let seasons):
                let view = ChangeSeasonsView()
                view.setup(seasons: seasons)
                return view
            }
        }()
        
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
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            self?.open(error: error) ?? .never()
        }
        
        let output = viewModel.configure(input: ChangeProfileViewModel.Input(
            changedField: mainView.changedField
        ))
        
        output.activity
            .drive(Binder(mainView) { base, activity in
                base.activity(activity)
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
extension ChangeProfileViewController {
    static func make(name: String?) -> ChangeProfileViewController {
        let vc = ChangeProfileViewController(field: .name(name))
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "ChangeProfile.Title.Name".localized
        return vc
    }
    
    static func make(size: Size?) -> ChangeProfileViewController {
        let vc = ChangeProfileViewController(field: .size(size))
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "ChangeProfile.Title.Size".localized
        return vc
    }
    
    static func make(gender: Gender?) -> ChangeProfileViewController {
        let vc = ChangeProfileViewController(field: .gender(gender))
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "ChangeProfile.Title.Gender".localized
        return vc
    }
    
    static func make(height: Height?) -> ChangeProfileViewController {
        let vc = ChangeProfileViewController(field: .height(height))
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "ChangeProfile.Title.Height".localized
        return vc
    }
    
    static func make(occasions: [Occasion]?) -> ChangeProfileViewController {
        let vc = ChangeProfileViewController(field: .occasions(occasions))
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "ChangeProfile.Title.Occasions".localized
        return vc
    }
    
    static func make(seasons: [Season]?) -> ChangeProfileViewController {
        let vc = ChangeProfileViewController(field: .seasons(seasons))
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "ChangeProfile.Title.Seasons".localized
        return vc
    }
}

// MARK: Private
private extension ChangeProfileViewController {
    enum Field {
        case name(String?)
        case size(Size?)
        case gender(Gender?)
        case height(Height?)
        case occasions([Occasion]?)
        case seasons([Season]?)
    }
    
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self else { return Disposables.create() }
                
                let vc = TryAgainViewController.make(error: error) {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
    
    func route(_ route: ChangeProfileViewModel.Route) {
        switch route {
        case .close:
            navigationController?.popViewController(animated: true)
        }
    }
}
