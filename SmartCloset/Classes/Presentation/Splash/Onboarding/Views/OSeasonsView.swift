//
//  OSeasonsView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 27.01.2025.
//

import UIKit

final class OSeasonsView: UIView {
    private let complete: ([Season]?) -> Void
    
    init(complete: @escaping ([Season]?) -> Void) {
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
private extension OSeasonsView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension OSeasonsView {
    func makeConstraints() {
        
    }
}

// MARK: Lazy initialization
private extension OSeasonsView {
    
}
