//
//  CLItemsCollectionSelectItemCell.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 07.02.2025.
//

import UIKit

final class CLItemsCollectionSelectItemCell: UICollectionViewCell {
    lazy var container = makeContainer()
    lazy var addIconView = makeAddIconView()
    lazy var label = makeLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.regular(size: 16.scale))
        .lineHeight(22.scale)
    
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
extension CLItemsCollectionSelectItemCell {
    func setup(itemCategory: ItemCategory) {
        let name = ItemCategory.DefaultLocalized().name(category: itemCategory)
        label.attributedText = name.attributed(with: attrs)
    }
}

// MARK: Private
private extension CLItemsCollectionSelectItemCell {
    func initialize() {
        backgroundColor = UIColor.clear
        
        contentView.backgroundColor = Appearance.main400.withAlphaComponent(0.5)
        contentView.layer.cornerRadius = 8.scale
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension CLItemsCollectionSelectItemCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addIconView.widthAnchor.constraint(equalToConstant: 32.scale),
            addIconView.heightAnchor.constraint(equalToConstant: 32.scale),
            addIconView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            addIconView.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 37.scale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CLItemsCollectionSelectItemCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeAddIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "CreateLook.Add")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
