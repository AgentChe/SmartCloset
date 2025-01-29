//
//  AvatarActionSheetController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import UIKit
import RxSwift

final class AvatarActionSheetController: UIViewController {
    enum Action {
        case takePhoto
        case chooseFromGallery
        case delete
    }
    
    private lazy var mainView = AvatarActionSheetView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let result: (Action) -> Void
    
    private init(result: @escaping (Action) -> Void) {
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
        
        Observable
            .merge(
                mainView.takePhotoButton.rx.tap
                    .map { Action.takePhoto },
                mainView.chooseFromGalleryButton.rx.tap
                    .map { Action.chooseFromGallery },
                mainView.deleteButton.rx.tap
                    .map { Action.delete }
            )
            .bind(to: Binder(self) { base, action in
                base.dismiss(animated: true) {
                    base.result(action)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension AvatarActionSheetController {
    static func make(result: @escaping (Action) -> Void) -> AvatarActionSheetController {
        let vc = AvatarActionSheetController(result: result)
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [
                .custom { context in
                    return 188.scale
                }
            ]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        return vc
    }
}
