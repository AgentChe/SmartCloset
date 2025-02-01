//
//  CountLabel.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 01.02.2025.
//

import UIKit

final class CountLabel: PaddingLabel {
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.SofiaSans.bold(size: 12.scale))
        .textAlignment(.center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
    }
}

// MARK: Public
extension CountLabel {
    func setup(count: Int) {
        isHidden = count == 0
        attributedText = String(count).attributed(with: attrs)
    }
}

// MARK: Private
private extension CountLabel {
    func initialize() {
        backgroundColor = Appearance.mono100
        layer.masksToBounds = true
        insets = UIEdgeInsets(value: 4.scale)
    }
}
