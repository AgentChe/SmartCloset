//
//  InspirationItemCategoryButton.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 04.02.2025.
//

import UIKit

final class InspirationItemCategoryButton: UIButton {
    lazy var categoryLabel = makeLabel()
    lazy var textLabel = makeLabel()
    lazy var iconView = makeImageView()
    
    private(set) var itemCategory: ItemCategory?
    
    private lazy var categoryAttrs = TextAttributes()
        .textColor(Appearance.mono100.withAlphaComponent(0.5))
        .font(Fonts.SofiaSans.regular(size: 14.scale))
        .lineHeight(20.scale)
        .textAlignment(.left)
    private lazy var textAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.bold(size: 16.scale))
        .lineHeight(20.scale)
        .letterSpacing(-0.32.scale)
        .textAlignment(.left)
    
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
extension InspirationItemCategoryButton {
    func setup(category: ItemCategory, season: Season) {
        self.itemCategory = category
        
        let categoryName = ItemCategory.DefaultLocalized().name(category: category)
        categoryLabel.attributedText = categoryName.attributed(with: categoryAttrs)
        
        textLabel.attributedText = category.text.attributed(with: textAttrs)
        
        iconView.image = UIImage(named: category.iconName)
        
        backgroundColor = {
            switch season {
            case .winter:
                return UIColor(integralRed: 210, green: 220, blue: 234)
            case .spring:
                return UIColor(integralRed: 243, green: 211, blue: 221)
            case .summer:
                return UIColor(integralRed: 210, green: 237, blue: 145)
            case .autumn:
                return UIColor(integralRed: 223, green: 220, blue: 213)
            }
        }()
    }
}

// MARK: Private
private extension InspirationItemCategoryButton {
    func initialize() {
        layer.cornerRadius = 12.scale
        layer.masksToBounds = true
        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.main400.cgColor
    }
}

// MARK: Make constraints
private extension InspirationItemCategoryButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            categoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 94.scale),
            iconView.heightAnchor.constraint(equalToConstant: 105.scale),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension InspirationItemCategoryButton {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension ItemCategory {
    var text: String {
        switch self {
        case .tops:
            return "Inspiration.ItemCategory.Text.Tops".localized
        case .bottoms:
            return "Inspiration.ItemCategory.Text.Bottoms".localized
        case .shoes:
            return "Inspiration.ItemCategory.Text.Shoes".localized
        case .bags:
            return "Inspiration.ItemCategory.Text.Bags".localized
        case .accessories:
            return "Inspiration.ItemCategory.Text.Accessories".localized
        }
    }
    
    var iconName: String {
        switch self {
        case .tops:
            return "Inspiration.ItemCategory.Tops".localized
        case .bottoms:
            return "Inspiration.ItemCategory.Bottoms".localized
        case .shoes:
            return "Inspiration.ItemCategory.Shoes".localized
        case .bags:
            return "Inspiration.ItemCategory.Bags".localized
        case .accessories:
            return "Inspiration.ItemCategory.Accessories".localized
        }
    }
}
