//
//  OGenderButton.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 28.01.2025.
//

import UIKit

final class OGenderButton: UIButton {
    lazy var marked: Bool = false {
        didSet {
            update()
        }
    }
    
    lazy var iconView = makeImageView()
    lazy var label = makeLabel()
    
    let gender: Gender
    
    init(gender: Gender) {
        self.gender = gender
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OGenderButton {
    func initialize() {
        layer.cornerRadius = 8.scale
    }
    
    func update() {
        backgroundColor = marked ? Appearance.main100 : Appearance.main500
    }
}

// MARK: Make constraints
private extension OGenderButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 87.scale),
            iconView.heightAnchor.constraint(equalToConstant: 84.scale),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 27.5.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OGenderButton {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = {
            switch gender {
            case .female:
                return UIImage(named: "Onboarding.Female")
            case .male:
                return UIImage(named: "Onboarding.Male")
            }
        }()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.bold(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = Gender.DefaultLocalized(gender: gender).name.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
