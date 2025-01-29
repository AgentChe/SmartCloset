//
//  SettingsView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import UIKit

final class SettingsView: UIView {
    lazy var profileButton = makeRouteButton(route: .profile)
    lazy var termsOfUseButton = makeRouteButton(route: .termsOfUse)
    lazy var privacyPolicyButton = makeRouteButton(route: .privacyPolicy)
    lazy var supportButton = makeRouteButton(route: .support)
    
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
private extension SettingsView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension SettingsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            profileButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            profileButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            profileButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            termsOfUseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            termsOfUseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            termsOfUseButton.topAnchor.constraint(equalTo: profileButton.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            privacyPolicyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            privacyPolicyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            privacyPolicyButton.topAnchor.constraint(equalTo: termsOfUseButton.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            supportButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            supportButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            supportButton.topAnchor.constraint(equalTo: privacyPolicyButton.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsView {
    func makeRouteButton(route: SettingsRouteButton.Route) -> SettingsRouteButton {
        let view = SettingsRouteButton(route: route)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
