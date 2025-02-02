//
//  SIFilterTableCell.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 01.02.2025.
//

import UIKit

final class SIFilterTableCell: UITableViewCell {
    lazy var titleLabel = makeTitleLabel()
    lazy var container = makeContainer()
    lazy var valueLabel = makeLabel()
    lazy var iconView = makeIconView()
    
    private lazy var placeholderAttrs = TextAttributes()
        .textColor(Appearance.mono100.withAlphaComponent(0.5))
        .font(Fonts.SofiaSans.regular(size: 16.scale))
        .lineHeight(22.scale)
        .textAlignment(.left)
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.regular(size: 16.scale))
        .lineHeight(22.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SIFilterTableCell {
    func setup(category: ItemCategory?) {
        titleLabel.attributedText = "SIFilter.Category.Title".localized.attributed(with: attrs)
        
        let categoryName: String? = {
            guard let category else { return nil }
            return ItemCategory.DefaultLocalized().name(category: category)
        }()
        let value = categoryName ?? "SIFilter.Category.Placeholder".localized
        let attrs = categoryName == nil ? placeholderAttrs : attrs
        valueLabel.attributedText = value.attributed(with: attrs)
    }
    
    func setup(type: ItemType?) {
        titleLabel.attributedText = "SIFilter.Type.Title".localized.attributed(with: attrs)
        
        let value = type ?? "SIFilter.Type.Placeholder".localized
        let attrs = type == nil ? placeholderAttrs : attrs
        valueLabel.attributedText = value.attributed(with: attrs)
    }
    
    func setup(material: Material?) {
        titleLabel.attributedText = "SIFilter.Material.Title".localized.attributed(with: attrs)
        
        let value = material?.name ?? "SIFilter.Material.Placeholder".localized
        let attrs = material?.name == nil ? placeholderAttrs : attrs
        valueLabel.attributedText = value.attributed(with: attrs)
    }
}

// MARK: Private
private extension SIFilterTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SIFilterTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.heightAnchor.constraint(equalToConstant: 44.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            valueLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SIFilterTableCell {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 3.scale
        view.backgroundColor = Appearance.main500
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "SIFilter.EditIcon")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
