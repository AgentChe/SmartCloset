//
//  WCCollectionCell.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 16.02.2025.
//

import UIKit

final class WCCollectionCell: UICollectionViewCell {
    lazy var label = makeLabel()
    lazy var container = makeContainer()
    lazy var firstLookView = makeLookView()
    lazy var secondLookView = makeLookView()
    lazy var thirdLookView = makeLookView()
    lazy var fourthLookView = makeLookView()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.regular(size: 16.scale))
        .lineHeight(22.scale)
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
extension WCCollectionCell {
    func setup(collection: Collection) {
        label.attributedText = collection.name.attributed(with: attrs)
        
        let firstLook = collection.looks[safe: 0]
        let secondLook = collection.looks[safe: 1]
        let thirdLook = collection.looks[safe: 2]
        let fourthLook = collection.looks[safe: 3]
        
        firstLookView.isHidden = firstLook == nil
        secondLookView.isHidden = secondLook == nil
        thirdLookView.isHidden = thirdLook == nil
        fourthLookView.isHidden = fourthLook == nil
        
        if let firstLook {
            firstLookView.setup(look: firstLook)
        }
        if let secondLook {
            secondLookView.setup(look: secondLook)
        }
        if let thirdLook {
            thirdLookView.setup(look: thirdLook)
        }
        if let fourthLook {
            fourthLookView.setup(look: fourthLook)
        }
    }
}

// MARK: Private
private extension WCCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension WCCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 370.scale)
        ])
        
        NSLayoutConstraint.activate([
            firstLookView.widthAnchor.constraint(equalToConstant: 168.scale),
            firstLookView.heightAnchor.constraint(equalToConstant: 174.scale),
            firstLookView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8.scale),
            firstLookView.topAnchor.constraint(equalTo: container.topAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            secondLookView.widthAnchor.constraint(equalToConstant: 168.scale),
            secondLookView.heightAnchor.constraint(equalToConstant: 174.scale),
            secondLookView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8.scale),
            secondLookView.topAnchor.constraint(equalTo: container.topAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            thirdLookView.widthAnchor.constraint(equalToConstant: 168.scale),
            thirdLookView.heightAnchor.constraint(equalToConstant: 174.scale),
            thirdLookView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8.scale),
            thirdLookView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            fourthLookView.widthAnchor.constraint(equalToConstant: 168.scale),
            fourthLookView.heightAnchor.constraint(equalToConstant: 174.scale),
            fourthLookView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8.scale),
            fourthLookView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WCCollectionCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main500
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLookView() -> WCCollectionItemView {
        let view = WCCollectionItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
