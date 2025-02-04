//
//  SearchItemsView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 01.02.2025.
//

import UIKit

final class SearchItemsView: UIView {
    lazy var inputField = makeInputView()
    lazy var filterButton = makeFilterButton()
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
private extension SearchItemsView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension SearchItemsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            inputField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            inputField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -69.scale),
            inputField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            filterButton.leadingAnchor.constraint(equalTo: inputField.trailingAnchor, constant: 10.scale),
            filterButton.topAnchor.constraint(equalTo: inputField.topAnchor),
            filterButton.bottomAnchor.constraint(equalTo: inputField.bottomAnchor),
            filterButton.heightAnchor.constraint(equalTo: filterButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: inputField.bottomAnchor, constant: 1.scale),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            emptyView.topAnchor.constraint(equalTo: inputField.bottomAnchor, constant: 83.scale),
            emptyView.heightAnchor.constraint(equalToConstant: 200.scale)
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
private extension SearchItemsView {
    func makeInputView() -> SearchItemsInputView {
        let view = SearchItemsInputView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFilterButton() -> SearchItemsFilterButton {
        let view = SearchItemsFilterButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> SICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20.scale
        layout.minimumInteritemSpacing = 18.scale
        layout.itemSize = CGSize(width: 168.scale, height: 174.scale)
        
        let view = SICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(vertical: 10.scale, horizontal: 16.scale)
        view.setContentOffset(CGPoint(x: 0, y: -10.scale), animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmptyView() -> SearchItemsEmptyView {
        let view = SearchItemsEmptyView()
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
