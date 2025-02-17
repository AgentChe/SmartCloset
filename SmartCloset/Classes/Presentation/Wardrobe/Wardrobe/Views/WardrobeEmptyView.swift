//
//  WardrobeEmptyView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 17.02.2025.
//

import UIKit

final class WardrobeEmptyView: UIView {
    enum Tab {
        case item
        case looks
        case collections
    }
    
    lazy var addButton = makeAddButton()
    lazy var label = makeLabel()
    
    private let tab: Tab
    
    init(tab: Tab) {
        self.tab = tab
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension WardrobeEmptyView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make contraints
private extension WardrobeEmptyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 68.scale),
            addButton.heightAnchor.constraint(equalToConstant: 68.scale),
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 83.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WardrobeEmptyView {
    func makeAddButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Wardrobe.AddObject"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.regular(size: 16.scale))
            .lineHeight(20.scale)
            .textAlignment(.center)
            .letterSpacing(-0.32.scale)
        
        let view = UILabel()
        view.attributedText = tab.text.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension WardrobeEmptyView.Tab {
    var text: String {
        switch self {
        case .item:
            return "Wardrobe.Empty.Items".localized
        case .looks:
            return "Wardrobe.Empty.Looks".localized
        case .collections:
            return "Wardrobe.Empty.Collections".localized
        }
    }
}
