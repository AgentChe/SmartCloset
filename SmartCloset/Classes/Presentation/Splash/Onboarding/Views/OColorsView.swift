//
//  OColorsView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 27.01.2025.
//

import UIKit

final class OColorsView: UIView {
    private let complete: ([String]?) -> Void
    
    init(complete: @escaping ([String]?) -> Void) {
        self.complete = complete
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OColorsView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension OColorsView {
    func makeConstraints() {
        
    }
}

// MARK: Lazy initialization
private extension OColorsView {
    
}
