//
//  ECCDCollectionView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 11.02.2025.
//

import UIKit

final class ECCDCollectionView: UIView {
    lazy var firstLookView = makeLookView(look: collection.looks[safe: 0])
    lazy var secondLookView = makeLookView(look: collection.looks[safe: 1])
    lazy var thirdLookView = makeLookView(look: collection.looks[safe: 2])
    lazy var fourthLookView = makeLookView(look: collection.looks[safe: 3])
    
    private let collection: Collection
    
    init(collection: Collection) {
        self.collection = collection
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ECCDCollectionView {
    func initialize() {
        backgroundColor = Appearance.main500
        layer.cornerRadius = 4.scale
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension ECCDCollectionView {
    func makeConstraints() {
        if let firstLookView {
            NSLayoutConstraint.activate([
                firstLookView.widthAnchor.constraint(equalToConstant: 65.scale),
                firstLookView.heightAnchor.constraint(equalToConstant: 67.scale),
                firstLookView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4.scale),
                firstLookView.topAnchor.constraint(equalTo: topAnchor, constant: 4.scale)
            ])
        }
        
        if let secondLookView {
            NSLayoutConstraint.activate([
                secondLookView.widthAnchor.constraint(equalToConstant: 65.scale),
                secondLookView.heightAnchor.constraint(equalToConstant: 67.scale),
                secondLookView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4.scale),
                secondLookView.topAnchor.constraint(equalTo: topAnchor, constant: 4.scale)
            ])
        }
        
        if let thirdLookView {
            NSLayoutConstraint.activate([
                thirdLookView.widthAnchor.constraint(equalToConstant: 65.scale),
                thirdLookView.heightAnchor.constraint(equalToConstant: 67.scale),
                thirdLookView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4.scale),
                thirdLookView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.scale)
            ])
        }
        
        if let fourthLookView {
            NSLayoutConstraint.activate([
                fourthLookView.widthAnchor.constraint(equalToConstant: 65.scale),
                fourthLookView.heightAnchor.constraint(equalToConstant: 67.scale),
                fourthLookView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4.scale),
                fourthLookView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.scale)
            ])
        }
    }
}

// MARK: Lazy initialization
private extension ECCDCollectionView {
    func makeLookView(look: Look?) -> ECCDCollectionLookView? {
        guard let look else { return nil }
        
        let view = ECCDCollectionLookView(look: look)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
