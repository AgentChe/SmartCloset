//
//  MainView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 28.01.2025.
//

import UIKit

final class MainView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstratins()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension MainView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension MainView {
    func makeConstratins() {
        
    }
}

// MARK: Lazy initialization
private extension MainView {
    
}
