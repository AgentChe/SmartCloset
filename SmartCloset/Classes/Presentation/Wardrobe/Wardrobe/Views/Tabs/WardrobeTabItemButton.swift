//
//  WardrobeTabItemButton.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 16.02.2025.
//

import UIKit

final class WardrobeTabItemButton: UIButton {
    enum Tab {
        case items, looks, collections
    }
    
    lazy var marked: Bool = false {
        didSet {
            update()
        }
    }
    
    lazy var label = makeLabel()
    lazy var separator = makeSeparator()
    
    let tab: Tab
    
    init(tab: Tab) {
        self.tab = tab
        
        super.init(frame: .zero)
        
        makeConstraints()
        initiailize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension WardrobeTabItemButton {
    func initiailize() {
        backgroundColor = UIColor.clear
    }
    
    func update() {
        separator.backgroundColor = marked ? Appearance.mono100 : UIColor(integralRed: 232, green: 232, blue: 232)
    }
}

// MARK: Make constraints
private extension WardrobeTabItemButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1.scale),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WardrobeTabItemButton {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.regular(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = tab.title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additiona
private extension WardrobeTabItemButton.Tab {
    var title: String {
        switch self {
        case .items:
            return "Wardrobe.Tabs.Items".localized
        case .looks:
            return "Wardrobe.Tabs.Looks".localized
        case .collections:
            return "Wardrobe.Tabs.Collections".localized
        }
    }
}
