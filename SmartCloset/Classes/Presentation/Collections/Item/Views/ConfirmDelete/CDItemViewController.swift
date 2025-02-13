//
//  CDItemViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 13.02.2025.
//

import UIKit
import RxSwift

final class CDItemViewController: UIViewController {
    private let mainView: CDItemView
    
    private lazy var disposeBag = DisposeBag()
    
    private let remove: () -> Void
    
    private init(item: Item, remove: @escaping () -> Void) {
        self.mainView = CDItemView(item: item)
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
extension CDItemViewController {
    static func make(item: Item, remove: @escaping () -> Void) -> CDItemViewController {
        let vc = CDItemViewController(item: item, remove: remove)
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

// MARK: Private
private extension CDItemViewController {
    func dismiss(completion: (() -> Void)? = nil) {
        mainView.animateDismiss { [weak self] in
            self?.dismiss(animated: false) {
                completion?()
            }
        }
    }
}
