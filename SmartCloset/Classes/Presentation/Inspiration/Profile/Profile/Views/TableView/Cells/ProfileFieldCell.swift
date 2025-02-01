//
//  ProfileFieldCell.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import UIKit

final class ProfileFieldCell: UITableViewCell {
    lazy var titleLabel = makeLabel()
    lazy var valueLabel = makeLabel()
    lazy var arrowView = makeArrowView()
    lazy var separator = makeSeparator()
    
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.regular(size: 16.scale))
        .lineHeight(22.scale)
        .textAlignment(.left)
    private lazy var valueAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.regular(size: 16.scale))
        .lineHeight(22.scale)
        .textAlignment(.right)
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
extension ProfileFieldCell {
    func setup(name: String?) {
        titleLabel.attributedText = "Profile.Name".localized.attributed(with: titleAttrs)
        
        let value = name ?? "Profile.NotData".localized
        valueLabel.attributedText = value.attributed(with: valueAttrs)
    }
    
    func setup(size: Size?) {
        titleLabel.attributedText = "Profile.Size".localized.attributed(with: titleAttrs)
        
        let value: String = {
            guard let size else { return "Profile.NotData".localized }
            return Size.DefaultLocalized(size: size).name
        }()
        valueLabel.attributedText = value.attributed(with: valueAttrs)
    }
    
    func setup(gender: Gender?) {
        titleLabel.attributedText = "Profile.Gender".localized.attributed(with: titleAttrs)
        
        let value: String = {
            guard let gender else { return "Profile.NotData".localized }
            return Gender.DefaultLocalized(gender: gender).name
        }()
        valueLabel.attributedText = value.attributed(with: valueAttrs)
    }
    
    func setup(height: Height?) {
        titleLabel.attributedText = "Profile.Height".localized.attributed(with: titleAttrs)
        
        let value: String = {
            guard let height else { return "Profile.NotData".localized }
            return Height.DefaultLocalized(height: height).value ?? "Profile.NotData".localized
        }()
        valueLabel.attributedText = value.attributed(with: valueAttrs)
    }
    
    func setup(occasions: [Occasion]?) {
        titleLabel.attributedText = "Profile.Occasions".localized.attributed(with: titleAttrs)
        
        let value: String = {
            guard let occasions else { return "Profile.NotData".localized }
            return occasions
                .map { Occasion.DefaultLocalized(occasion: $0).name }
                .joined(separator: ", ")
        }()
        valueLabel.attributedText = value.attributed(with: valueAttrs)
    }
    
    func setup(season: Season?) {
        titleLabel.attributedText = "Profile.Seasons".localized.attributed(with: titleAttrs)
        
        let value: String = {
            guard let season else { return "Profile.NotData".localized }
            return Season.DefaultLocalized(season: season).name
        }()
        valueLabel.attributedText = value.attributed(with: valueAttrs)
    }
}

// MARK: Private
private extension ProfileFieldCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        valueLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        valueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}

// MARK: Make constraints
private extension ProfileFieldCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18.scale)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16.scale),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -46.scale),
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18.scale)
        ])
        
        NSLayoutConstraint.activate([
            arrowView.widthAnchor.constraint(equalToConstant: 24.scale),
            arrowView.heightAnchor.constraint(equalToConstant: 24.scale),
            arrowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            arrowView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileFieldCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeArrowView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Profile.Arrow")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main400
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
