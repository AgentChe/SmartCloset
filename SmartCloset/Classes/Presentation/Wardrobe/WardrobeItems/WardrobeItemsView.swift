//
//  WardrobeItemsView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 16.02.2025.
//

import UIKit

final class WardrobeItemsView: UIView {
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
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: 50.scale)
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
    func makeCollectionView() -> WICollectionView {
        let layout = UICollectionViewFlowLayout()
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
