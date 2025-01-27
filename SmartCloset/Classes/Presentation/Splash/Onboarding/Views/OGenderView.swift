//
//  OGenderView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 27.01.2025.
//

import UIKit

final class OGenderView: UIView {
    private let complete: (Gender?) -> Void
    
    init(complete: @escaping (Gender?) -> Void) {
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
private extension OGenderView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension OGenderView {
    func makeConstraints() {
        
    }
}

// MARK: Lazy initialization
private extension OGenderView {
    
}
