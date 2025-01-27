//
//  OOccasionsView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 27.01.2025.
//

import UIKit

final class OOccasionsView: UIView {
    private let complete: ([Occasion]?) -> Void
    
    init(complete: @escaping ([Occasion]?) -> Void) {
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
private extension OOccasionsView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension OOccasionsView {
    func makeConstraints() {
        
    }
}

// MARK: Lazy initialization
private extension OOccasionsView {
    
}
