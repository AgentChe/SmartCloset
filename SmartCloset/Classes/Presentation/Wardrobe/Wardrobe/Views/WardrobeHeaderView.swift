//
//  WardrobeHeaderView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 15.02.2025.
//

import UIKit
import Kingfisher

final class WardrobeHeaderView: UIView {
    lazy var settingsButton = makeSettingsButton()
    lazy var imageView = makeImageView()
    lazy var nameImagePlaceholderLabel = makeLabel()
    lazy var nameLabel = makeLabel()
    lazy var imageActionButton = makeImageActionButton()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.regular(size: 24.scale))
        .lineHeight(34.scale)
        .textAlignment(.center)
        .lineBreakMode(.byTruncatingTail)
    
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
extension WardrobeHeaderView {
    func setup(profile: Profile) {
        imageView.image = nil
        imageView.kf.setImage(with: profile.avatar)
        
        nameLabel.attributedText = profile.name?.attributed(with: nameAttrs)
        
        nameImagePlaceholderLabel.isHidden = profile.avatar != nil
        nameImagePlaceholderLabel.attributedText = {
            guard let first = profile.name?.first else { return "".attributed(with: nameAttrs) }
            return String(first).attributed(with: nameAttrs)
        }()
        
        let actionImage = UIImage(named: profile.avatar == nil ? "Wardrobe.AddPhoto" : "Wardrobe.EditPhoto")
        imageActionButton.setImage(actionImage, for: .normal)
    }
}

// MARK: Private
private extension WardrobeHeaderView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension WardrobeHeaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            settingsButton.widthAnchor.constraint(equalToConstant: 24.scale),
            settingsButton.heightAnchor.constraint(equalToConstant: 24.scale),
            settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            settingsButton.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 100.scale),
            imageView.heightAnchor.constraint(equalToConstant: 100.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameImagePlaceholderLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            nameImagePlaceholderLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 42.scale),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -42.scale),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageActionButton.widthAnchor.constraint(equalToConstant: 24.scale),
            imageActionButton.heightAnchor.constraint(equalToConstant: 24.scale),
            imageActionButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            imageActionButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WardrobeHeaderView {
    func makeSettingsButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Wardrobe.Settings"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.backgroundColor = Appearance.main300
        view.layer.cornerRadius = 50.scale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageActionButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
