//
//  InspirationCollectionButton.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 04.02.2025.
//

import UIKit

final class InspirationCollectionButton: UIButton {
    lazy var backgroundView = makeBackgroundView()
    lazy var headerLabel = makeTitleLabel()
    lazy var textLabel = makeTextLabel()
    
    private lazy var textAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.bold(size: 22.scale))
        .lineHeight(26.scale)
        .letterSpacing(-0.32.scale)
        .textAlignment(.left)
    
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
extension InspirationCollectionButton {
    func setup(gender: Gender, season: Season) {
        let genderCode: String = {
            switch gender {
            case .female:
                return "F"
            case .male:
                return "M"
            }
        }()
        
        let seasonCode: String = {
            switch season {
            case .winter:
                return "Winter"
            case .spring:
                return "Spring"
            case .summer:
                return "Summer"
            case .autumn:
                return "Autumn"
            }
        }()
        
        let imageName = String(format: "Inspiration.Collections.%@.%@", genderCode, seasonCode)
        backgroundView.image = UIImage(named: imageName)
        
        let text: String = {
            switch season {
            case .winter:
                return "Inspiration.CollectionsButton.Text.Winter".localized
            case .spring:
                return "Inspiration.CollectionsButton.Text.Spring".localized
            case .summer:
                return "Inspiration.CollectionsButton.Text.Summer".localized
            case .autumn:
                return "Inspiration.CollectionsButton.Text.Autumn".localized
            }
        }()
        textLabel.attributedText = text.attributed(with: textAttrs)
    }
}

// MARK: Private
private extension InspirationCollectionButton {
    func initialize() {
        layer.cornerRadius = 12.scale
        layer.masksToBounds = true
        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.main400.cgColor
    }
}

// MARK: Make constraints
private extension InspirationCollectionButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension InspirationCollectionButton {
    func makeBackgroundView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 12.scale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.regular(size: 14.scale))
            .lineHeight(20.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Inspiration.CollectionsButton.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
