//
//  MCIButton.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 11.02.2025.
//

import UIKit

final class MCIButton: UIButton {
    lazy var container = makeContainer()
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    
    let method: MethodCreationItem
    
    init(method: MethodCreationItem) {
        self.method = method
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension MCIButton {
    func initialize() {
        backgroundColor = {
            switch method {
            case .database, .gallery:
                return Appearance.main500
            case .takePhoto:
                return Appearance.main100
            }
        }()
    }
}

// MARK: Make constraints
private extension MCIButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            iconView.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 34.scale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension MCIButton {
    func makeContainer() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: method.iconName)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.bold(size: 16.scale))
            .lineHeight(26.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = method.title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}

// MARK: Additional
private extension MethodCreationItem {
    var iconName: String {
        switch self {
        case .database:
            return "MethodCreationItem.Database"
        case .gallery:
            return "MethodCreationItem.Gallery"
        case .takePhoto:
            return "MethodCreationItem.TakePhoto"
        }
    }
    
    var title: String {
        switch self {
        case .database:
            return "MethodCreationItem.Database".localized
        case .gallery:
            return "MethodCreationItem.Gallery".localized
        case .takePhoto:
            return "MethodCreationItem.TakePhoto".localized
        }
    }
}
