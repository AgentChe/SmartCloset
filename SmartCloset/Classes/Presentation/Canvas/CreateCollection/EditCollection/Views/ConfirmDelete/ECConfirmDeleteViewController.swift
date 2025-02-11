//
//  ECConfirmDeleteViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 11.02.2025.
//

import UIKit
import RxSwift

final class ECConfirmDeleteViewController: UIViewController {
    private let mainView: ECConfirmDeleteView
    
    private lazy var disposeBag = DisposeBag()
    
    private let remove: () -> Void
    
    private init(look: Look, remove: @escaping () -> Void) {
        self.mainView = ECConfirmDeleteView(entity: .look(look))
        self.remove = remove
        
        super.init(nibName: nil, bundle: nil)
    }
    
    private init(collection: Collection, remove: @escaping () -> Void) {
        self.mainView = ECConfirmDeleteView(entity: .collection(collection))
        self.remove = remove
        
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
        
        mainView.cancelButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss()
            })
            .disposed(by: disposeBag)
        
        mainView.removeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss {
                    base.remove()
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        mainView.animateShow()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        dismiss()
    }
}

// MARK: Public
extension ECConfirmDeleteViewController {
    static func make(look: Look, remove: @escaping () -> Void) -> ECConfirmDeleteViewController {
        let vc = ECConfirmDeleteViewController(look: look, remove: remove)
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
    
    static func make(collection: Collection, remove: @escaping () -> Void) -> ECConfirmDeleteViewController {
        let vc = ECConfirmDeleteViewController(collection: collection, remove: remove)
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

// MARK: Private
private extension ECConfirmDeleteViewController {
    func dismiss(completion: (() -> Void)? = nil) {
        mainView.animateDismiss { [weak self] in
            self?.dismiss(animated: false) {
                completion?()
            }
        }
    }
}
