//
//  EditLookView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 08.02.2025.
//

import UIKit

final class EditLookView: UIView {
    lazy var topsCollectionView = makeCollectionView()
    lazy var bottomsCollectionView = makeCollectionView()
    lazy var shoesCollectionView = makeCollectionView()
    lazy var bagsCollectionView = makeCollectionView()
    lazy var accessoriesCollectionView = makeCollectionView()
    lazy var saveButton = makeSaveButton()
    lazy var preloader = makePreloader()
    
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
private extension EditLookView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension EditLookView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            topsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topsCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.scale),
            topsCollectionView.heightAnchor.constraint(equalTo: bottomsCollectionView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomsCollectionView.topAnchor.constraint(equalTo: topsCollectionView.bottomAnchor, constant: 16.scale),
            bottomsCollectionView.heightAnchor.constraint(equalTo: shoesCollectionView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            shoesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shoesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shoesCollectionView.topAnchor.constraint(equalTo: bottomsCollectionView.bottomAnchor, constant: 16.scale),
            shoesCollectionView.heightAnchor.constraint(equalTo: bagsCollectionView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bagsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bagsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bagsCollectionView.topAnchor.constraint(equalTo: shoesCollectionView.bottomAnchor, constant: 16.scale),
            bagsCollectionView.heightAnchor.constraint(equalTo: accessoriesCollectionView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            accessoriesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            accessoriesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            accessoriesCollectionView.topAnchor.constraint(equalTo: bagsCollectionView.bottomAnchor, constant: 16.scale),
            accessoriesCollectionView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            saveButton.heightAnchor.constraint(equalToConstant: 52.scale),
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.widthAnchor.constraint(equalToConstant: 45.scale),
            preloader.heightAnchor.constraint(equalToConstant: 45.scale),
            preloader.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension EditLookView {
    func makeCollectionView() -> CLItemsCollectionView {
        let layout = CLItemsCollectionLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 70.scale
        layout.minimumInteritemSpacing = 0
        
        let view = CLItemsCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSaveButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.bold(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Save".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main100
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
