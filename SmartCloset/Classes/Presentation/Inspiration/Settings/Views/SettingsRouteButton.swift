//
//  SettingsRouteButton.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import UIKit

final class SettingsRouteButton: UIButton {
    enum Route {
        case profile
        case termsOfUse
        case privacyPolicy
        case support
    }
    
    lazy var label = makeLabel()
    lazy var arrowView = makeArrowView()
    lazy var separator = makeSeparator()
    
    private let route: Route
    
    init(route: Route) {
        self.route = route
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension SettingsRouteButton {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension SettingsRouteButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18.scale)
        ])
        
        NSLayoutConstraint.activate([
            arrowView.widthAnchor.constraint(equalToConstant: 24.scale),
            arrowView.heightAnchor.constraint(equalToConstant: 24.scale),
            arrowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            arrowView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.scale),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsRouteButton {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.regular(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = route.title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeArrowView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Settings.Arrow")
        view.isHidden = route.arrowHidden
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main400
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional (Private)
private extension SettingsRouteButton.Route {
    var title: String {
        switch self {
        case .profile:
            return "Settings.Profile".localized
        case .termsOfUse:
            return "Settings.TermsOfUse".localized
        case .privacyPolicy:
            return "Settings.PrivacyPolicy".localized
        case .support:
            return "Settings.Support".localized
        }
    }
    
    var arrowHidden: Bool {
        switch self {
        case .profile:
            return false
        case .termsOfUse, .privacyPolicy, .support:
            return true
        }
    }
}
