//
//  MainViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 28.01.2025.
//

import UIKit

final class MainViewController: UIViewController {
    private lazy var mainView = MainView()
    
    override func loadView() {
        view = mainView
    }
}

// MARK: Public
extension MainViewController {
    static func make() -> MainViewController {
        MainViewController()
    }
}
