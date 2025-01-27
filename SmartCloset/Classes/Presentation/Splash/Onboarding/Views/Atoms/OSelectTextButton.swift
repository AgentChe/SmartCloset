//
//  OSelectButton.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 27.01.2025.
//

import UIKit

final class OSelectTextButton<T>: UIButton {
    lazy var marked = false {
        didSet {
            update()
        }
    }
    
    let object: T
    
    init(object: T, title: String) {
        self.object = object
        
        super.init(frame: .zero)
        
        initialize()
        update()
        
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.bold(size: 16.scale))
        setAttributedTitle(title.attributed(with: attrs), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSelectTextButton {
    func initialize() {
        layer.cornerRadius = 8.scale
        layer.masksToBounds = true
    }
    
    func update() {
        backgroundColor = marked ? Appearance.main100 : Appearance.main500
    }
}
