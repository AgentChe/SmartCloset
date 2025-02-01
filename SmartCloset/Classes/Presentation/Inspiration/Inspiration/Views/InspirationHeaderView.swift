//
//  InspirationHeaderView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import UIKit

final class InspirationHeaderView: UIView {
    struct Data {
        let season: Season?
        let name: String?
    }
    
    lazy var backgroundView = makeBackgroundView()
    lazy var label = makeLabel()
    lazy var settingsButton = makeSettingsButton()
    lazy var searchButton = makeSearchButton()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.bold(size: 22.scale))
        .lineHeight(26.scale)
        .textAlignment(.left)
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
extension InspirationHeaderView {
    func setup(data: Data) {
        updateLabel(data: data)
        updateBackground(season: data.season)
    }
}

// MARK: Private
private extension InspirationHeaderView {
    func initialize() {
        layer.cornerRadius = 16.scale
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.masksToBounds = true
    }
    
    func updateLabel(data: Data) {
        let string: String = {
            let season: String? = {
                guard let season = data.season else { return nil }
                return Season.DefaultLocalized(season: season).symbol
            }()
            
            return [season, data.name]
                .compactMap { $0 }
                .joined(separator: " ")
        }()
        
        label.attributedText = string.attributed(with: attrs)
    }
    
    func updateBackground(season: Season?) {
        guard let season else { return }
        
        backgroundView.image = {
            switch season {
            case .winter:
                return UIImage(named: "Inspiration.Header.Winter")
            case .spring:
                return UIImage(named: "Inspiration.Header.Spring")
            case .summer:
                return UIImage(named: "Inspiration.Header.Summer")
            case .autumn:
                return UIImage(named: "Inspiration.Header.Autumn")
            }
        }()
    }
}

// MARK: Make constraints
private extension InspirationHeaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -8.scale),
            label.centerYAnchor.constraint(equalTo: settingsButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            settingsButton.widthAnchor.constraint(equalToConstant: 24.scale),
            settingsButton.heightAnchor.constraint(equalToConstant: 24.scale),
            settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            settingsButton.topAnchor.constraint(equalTo: topAnchor, constant: 68.scale)
        ])
        
        NSLayoutConstraint.activate([
            searchButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            searchButton.heightAnchor.constraint(equalToConstant: 44.scale),
            searchButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension InspirationHeaderView {
    func makeBackgroundView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
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
    
    func makeSettingsButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Inspiration.Settings"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSearchButton() -> InspirationSearchButton {
        let view = InspirationSearchButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
