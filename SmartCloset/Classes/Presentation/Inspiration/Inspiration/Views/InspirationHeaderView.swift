//
//  InspirationHeaderView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import UIKit

final class InspirationHeaderView: GradientView {
    lazy var settingsButton = makeSettingsButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension InspirationHeaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            settingsButton.widthAnchor.constraint(equalToConstant: 24.scale),
            settingsButton.heightAnchor.constraint(equalToConstant: 24.scale),
            settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            settingsButton.topAnchor.constraint(equalTo: topAnchor, constant: 68.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension InspirationHeaderView {
    func makeSettingsButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Inspiration.Settings"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
