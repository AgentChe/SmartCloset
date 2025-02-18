//
//  WardrobeItemsFavoriteButton.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 18.02.2025.
//

import UIKit

final class WardrobeItemsFavoriteButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WardrobeItemsFavoriteButton {
    func setup(favorite: Bool) {
        let icon = UIImage(named: favorite ? "Wardrobe.Favorite.T" : "Wardrobe.Favorite.F")
        setImage(icon, for: .normal)
    }
}

// MARK: Private
private extension WardrobeItemsFavoriteButton {
    func initialize() {
        backgroundColor = Appearance.main500
        layer.cornerRadius = 22.scale
        layer.masksToBounds = true
    }
}
