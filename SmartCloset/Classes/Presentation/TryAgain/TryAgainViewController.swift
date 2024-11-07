//
//  TryAgainViewController.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 06.09.2024.
//

import UIKit
import RxSwift

final class TryAgainViewController: UIViewController {
    private lazy var mainView = TryAgainView(error: error)
    
    private lazy var disposeBag = DisposeBag()
    
    private let error: Error
    private let tryAgain: (() -> Void)?
    
    private init(error: Error, tryAgain: (() -> Void)?) {
        self.error = error
        self.tryAgain = tryAgain
        
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
        
        mainView.tryAgainButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true) { [weak self] in
                    self?.tryAgain?()
                }
            })
            .disposed(by: disposeBag)
        
        mainView.contactButton.rx.tap
            .bind(to: Binder(self) { base, void in
                UIApplication.shared.open(GlobalDefinitions.contactUsUrl)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension TryAgainViewController {
    static func make(error: Error, tryAgain: (() -> Void)? = nil) -> TryAgainViewController {
        TryAgainViewController(error: error, tryAgain: tryAgain)
    }
}
