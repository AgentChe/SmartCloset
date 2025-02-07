//
//  CanvasHeaderView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 06.02.2025.
//

import UIKit

final class CanvasHeaderView: UIView {
    lazy var backgroundView = makeImageView()
    lazy var label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CanvasHeaderView {
    func setup(season: Season) {
        backgroundView.image = {
            switch season {
            case .winter:
                return UIImage(named: "Canvas.Header.Winter")
            case .spring:
                return UIImage(named: "Canvas.Header.Spring")
            case .summer:
                return UIImage(named: "Canvas.Header.Summer")
            case .autumn:
                return UIImage(named: "Canvas.Header.Autumn")
            }
        }()
    }
}

// MARK: Make constraints
private extension CanvasHeaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CanvasHeaderView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.regular(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Canvas.Header".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
