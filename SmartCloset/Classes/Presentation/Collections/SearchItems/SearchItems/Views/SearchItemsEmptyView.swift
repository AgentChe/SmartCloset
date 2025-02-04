//
//  SearchItemsEmptyView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 03.02.2025.
//

import UIKit

final class SearchItemsEmptyView: UIView {
    enum Mode {
        case whatLooking
        case empty
    }
    
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.regular(size: 16.scale))
        .lineHeight(20.scale)
        .letterSpacing(-0.32.scale)
        .textAlignment(.center)
    
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
extension SearchItemsEmptyView {
    func setup(mode: Mode) {
        switch mode {
        case .whatLooking:
            imageView.image = UIImage(named: "SearchItems.WhatLooking")
            label.attributedText = "SearchItems.WhatLooking".localized.attributed(with: attrs)
        case .empty:
            imageView.image = UIImage(named: "SearchItems.Empty")
            label.attributedText = "SearchItems.Empty".localized.attributed(with: attrs)
        }
    }
}

// MARK: Private
private extension SearchItemsEmptyView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension SearchItemsEmptyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 168.scale),
            imageView.heightAnchor.constraint(equalToConstant: 168.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SearchItemsEmptyView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
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
}
