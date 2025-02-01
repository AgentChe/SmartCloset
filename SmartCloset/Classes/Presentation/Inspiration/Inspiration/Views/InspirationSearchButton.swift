//
//  InspirationSearchButton.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 01.02.2025.
//

import UIKit

final class InspirationSearchButton: UIButton {
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension InspirationSearchButton {
    func initialize() {
        backgroundColor = Appearance.mono200
        layer.cornerRadius = 8.scale
    }
}

// MARK: Make constraints
private extension InspirationSearchButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Private
private extension InspirationSearchButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Inspiration.Header.Search")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100.withAlphaComponent(0.5))
            .font(Fonts.SofiaSans.regular(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Inspiration.Header.Search".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
