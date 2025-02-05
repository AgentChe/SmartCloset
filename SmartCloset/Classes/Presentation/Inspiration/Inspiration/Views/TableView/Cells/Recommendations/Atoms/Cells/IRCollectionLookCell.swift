//
//  IRCollectionLookCell.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 05.02.2025.
//

import UIKit

// TODO
final class IRCollectionLookCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension IRCollectionLookCell {
    func setup(look: Look) {
        
    }
}

// MARK: Private
private extension IRCollectionLookCell {
    func initialize() {
        backgroundColor = UIColor.clear
        
        contentView.backgroundColor = UIColor.clear
        contentView.layer.cornerRadius = 10.scale
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = Appearance.main500.cgColor
        contentView.layer.borderWidth = 1.5.scale
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension IRCollectionLookCell {
    func makeConstraints() {
        
    }
}

// MARK: Lazy initialization
private extension IRCollectionLookCell {
    
}
