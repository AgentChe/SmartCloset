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
    lazy var wardrobeButton = makeWardrobeButton()
    lazy var shareButton = makeShareButton()
    lazy var preloader = makePreloader()
    
    private lazy var addToWardrobeAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.bold(size: 18.scale))
    private lazy var deleteFromWardrobeAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.SofiaSans.bold(size: 18.scale))
    
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
extension LookView {
    func wardrobe(_ wardrobe: Bool) {
        wardrobeButton.backgroundColor = wardrobe ? UIColor(integralRed: 249, green: 89, blue: 86) : Appearance.main100
        
        let attrs = wardrobe ? deleteFromWardrobeAttrs : addToWardrobeAttrs
        let title = wardrobe ? "Look.DeleteFromWardrobe".localized : "Look.AddToWardrobe".localized
        wardrobeButton.setAttributedTitle(title.attributed(with: attrs), for: .normal)
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
            collectionView.bottomAnchor.constraint(equalTo: wardrobeButton.topAnchor, constant: -30.scale),
            collectionView.heightAnchor.constraint(equalToConstant: 126.scale)
        ])
        
        NSLayoutConstraint.activate([
            wardrobeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            wardrobeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            wardrobeButton.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -16.scale),
            wardrobeButton.heightAnchor.constraint(equalToConstant: 52.scale)
        ])
        
        NSLayoutConstraint.activate([
            shareButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            shareButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            shareButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10.scale),
            shareButton.heightAnchor.constraint(equalToConstant: 52.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.widthAnchor.constraint(equalToConstant: 45.scale),
            preloader.heightAnchor.constraint(equalToConstant: 45.scale),
            preloader.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
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
    
    func makeWardrobeButton() -> UIButton {
        let view = UIButton()
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
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.color = Appearance.main100
        view.hidesWhenStopped = true
        view.stopAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
