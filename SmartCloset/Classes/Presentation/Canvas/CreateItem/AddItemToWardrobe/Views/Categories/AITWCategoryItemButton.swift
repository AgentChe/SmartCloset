//
//  AITWCategoryItemButton.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 13.02.2025.
//

import UIKit

final class AITWCategoryItemButton: UIButton {
    lazy var marked: Bool = false {
        didSet {
            update()
        }
    }
    
    lazy var iconContainer = makeIconContainer()
    lazy var iconView = makeIconView()
    lazy var nameLabel = makeNameLabel()
    lazy var selectedMarkerView = makeSelectedMarkerView()
    
    let category: ItemCategory
    
    init(category: ItemCategory) {
        self.category = category
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension AITWCategoryItemButton {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
    
    func update() {
        iconContainer.backgroundColor = marked ? Appearance.main200 : Appearance.main500
        selectedMarkerView.isHidden = !marked
    }
}

// MARK: Make constraints
private extension AITWCategoryItemButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconContainer.widthAnchor.constraint(equalToConstant: 50.scale),
            iconContainer.heightAnchor.constraint(equalToConstant: 50.scale),
            iconContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconContainer.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 32.scale),
            iconView.heightAnchor.constraint(equalToConstant: 32.scale),
            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            selectedMarkerView.widthAnchor.constraint(equalToConstant: 4.scale),
            selectedMarkerView.heightAnchor.constraint(equalToConstant: 4.scale),
            selectedMarkerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            selectedMarkerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension AITWCategoryItemButton {
    func makeIconContainer() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = 25.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let iconName = ItemCategory.DefaultIcon().assetIconName(category: category)
        
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: iconName)
        view.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.regular(size: 14.scale))
            .lineHeight(20.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.isUserInteractionEnabled = false
        view.attributedText = ItemCategory.DefaultLocalized().name(category: category).attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSelectedMarkerView() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = Appearance.main200
        view.layer.cornerRadius = 2.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
