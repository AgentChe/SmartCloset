//
//  LookView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 05.02.2025.
//

import UIKit

final class LookView: UIView {
    lazy var itemsView = makeItemsView()
    lazy var collectionView = makeCollectionView()
    lazy var addToWardrobeButton = makeAddToWardrobeButton()
    lazy var shareButton = makeShareButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension LookView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension LookView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            itemsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50.scale),
            itemsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50.scale),
            itemsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10.scale),
            itemsView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: addToWardrobeButton.topAnchor, constant: -30.scale),
            collectionView.heightAnchor.constraint(equalToConstant: 126.scale)
        ])
        
        NSLayoutConstraint.activate([
            addToWardrobeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            addToWardrobeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            addToWardrobeButton.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -16.scale),
            addToWardrobeButton.heightAnchor.constraint(equalToConstant: 52.scale)
        ])
        
        NSLayoutConstraint.activate([
            shareButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            shareButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            shareButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10.scale),
            shareButton.heightAnchor.constraint(equalToConstant: 52.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension LookView {
    func makeItemsView() -> LookItemsView {
        let view = LookItemsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> LookItemsCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16.scale
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 122.scale, height: 126.scale)
        
        let view = LookItemsCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsHorizontalScrollIndicator = false
        view.contentInset = UIEdgeInsets(horizontal: 16.scale)
        view.setContentOffset(CGPoint(x: 16.scale, y: 0), animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAddToWardrobeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.bold(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Look.AddToWardrobe".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main100
        view.layer.cornerRadius = 3.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeShareButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.bold(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Look.Share".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main400
        view.layer.cornerRadius = 3.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
