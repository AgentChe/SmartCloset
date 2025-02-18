//
//  WardrobeItemsView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 16.02.2025.
//

import UIKit

final class WardrobeItemsView: UIView {
    lazy var categoriesView = makeCategoriesView()
    lazy var selectTypeButton = makeSelectTypeButton()
    lazy var favoriteButton = makeFavoriteButton()
    lazy var collectionView = makeCollectionView()
    lazy var emptyView = makeEmptyView()
    lazy var centerPreloader = makePreloader()
    lazy var collectionPreloader = makePreloader()
    
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
private extension WardrobeItemsView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension WardrobeItemsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            categoriesView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            categoriesView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            categoriesView.topAnchor.constraint(equalTo: topAnchor, constant: 20.scale),
            categoriesView.heightAnchor.constraint(equalToConstant: 90.scale)
        ])
        
        NSLayoutConstraint.activate([
            selectTypeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            selectTypeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -76.scale),
            selectTypeButton.heightAnchor.constraint(equalToConstant: 44.scale),
            selectTypeButton.topAnchor.constraint(equalTo: categoriesView.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            favoriteButton.widthAnchor.constraint(equalToConstant: 44.scale),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44.scale),
            favoriteButton.centerYAnchor.constraint(equalTo: selectTypeButton.centerYAnchor),
            favoriteButton.leadingAnchor.constraint(equalTo: selectTypeButton.trailingAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: selectTypeButton.bottomAnchor, constant: 1.scale),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            centerPreloader.widthAnchor.constraint(equalToConstant: 45.scale),
            centerPreloader.heightAnchor.constraint(equalToConstant: 45.scale),
            centerPreloader.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            centerPreloader.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionPreloader.widthAnchor.constraint(equalToConstant: 32.scale),
            collectionPreloader.heightAnchor.constraint(equalToConstant: 32.scale),
            collectionPreloader.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            collectionPreloader.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WardrobeItemsView {
    func makeCategoriesView() -> AITWCategoriesView {
        let view = AITWCategoriesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSelectTypeButton() -> ICSelectTypeButton {
        let view = ICSelectTypeButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFavoriteButton() -> WardrobeItemsFavoriteButton {
        let view = WardrobeItemsFavoriteButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> WICollectionView {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20.scale
        layout.minimumInteritemSpacing = 14.scale
        layout.itemSize = CGSize(width: 171.scale, height: 175.scale)
        
        let view = WICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(vertical: 20.scale, horizontal: 16.scale)
        view.setContentOffset(CGPoint(x: 0, y: -20.scale), animated: false)
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
    
    func makeEmptyView() -> WardrobeEmptyView {
        let view = WardrobeEmptyView(tab: .item)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
