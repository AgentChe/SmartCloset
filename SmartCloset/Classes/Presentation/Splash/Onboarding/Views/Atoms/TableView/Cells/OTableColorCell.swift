//
//  OTableColorCell.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 28.01.2025.
//

import UIKit

final class OTableColorCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var colorView = makeColorView()
    lazy var nameLabel = makeNameLabel()
    lazy var checkView = makeCheckView()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.regular(size: 16.scale))
        .lineHeight(22.scale)
        .textAlignment(.left)
    
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
extension OTableColorCell {
    func setup(color: Color, marked: Bool) {
        colorView.backgroundColor = Color.DecodeBackendHex().uicolor(code: color.code)
        
        nameLabel.attributedText = color.name.attributed(with: attrs)
        
        checkView.image = {
            let named = marked ? "Onboarding.Check.S" : "Onboarding.Check.D"
            return UIImage(named: named)
        }()
    }
}

// MARK: Private
private extension OTableColorCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension OTableColorCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: 20.scale),
            colorView.heightAnchor.constraint(equalToConstant: 20.scale),
            colorView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            colorView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 46.scale),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -44.scale),
            nameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 13.scale),
            nameLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -13.scale)
        ])
        
        NSLayoutConstraint.activate([
            checkView.widthAnchor.constraint(equalToConstant: 18.scale),
            checkView.heightAnchor.constraint(equalToConstant: 18.scale),
            checkView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            checkView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OTableColorCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main500
        view.layer.cornerRadius = 8.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeColorView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeCheckView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
