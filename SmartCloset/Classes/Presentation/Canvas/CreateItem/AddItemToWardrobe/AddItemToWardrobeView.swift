//
//  AddItemToWardrobeView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 13.02.2025.
//

import UIKit

final class AddItemToWardrobeView: UIView {
    lazy var categoriesView = makeCategoriesView()
    lazy var selectTypeButton = makeSelectTypeButton()
    lazy var collectionView = makeCollectionView()
    lazy var saveButton = makeSaveButton()
    lazy var centerPreloader = makePreloader()
    lazy var collectionPreloader = makePreloader()
    lazy var savePreloader = makePreloader()
    
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
extension AddItemToWardrobeView {
    func canSave(_ canSave: Bool) {
        saveButton.isEnabled = canSave
        saveButton.backgroundColor = canSave ? Appearance.main100 : Appearance.main400
    }
}

// MARK: Private
private extension AddItemToWardrobeView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension AddItemToWardrobeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            categoriesView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            categoriesView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            categoriesView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.scale),
            categoriesView.heightAnchor.constraint(equalToConstant: 90.scale)
        ])
        
        NSLayoutConstraint.activate([
            selectTypeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            selectTypeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            selectTypeButton.heightAnchor.constraint(equalToConstant: 44.scale),
            selectTypeButton.topAnchor.constraint(equalTo: categoriesView.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: selectTypeButton.bottomAnchor, constant: 1.scale),
            collectionView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            saveButton.heightAnchor.constraint(equalToConstant: 52.scale),
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10.scale)
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
        
        NSLayoutConstraint.activate([
            savePreloader.widthAnchor.constraint(equalToConstant: 32.scale),
            savePreloader.heightAnchor.constraint(equalToConstant: 32.scale),
            savePreloader.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor),
            savePreloader.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension AddItemToWardrobeView {
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
    
    func makeCollectionView() -> AddItemToWardrobeCollectionView {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20.scale
        layout.minimumInteritemSpacing = 14.scale
        layout.itemSize = CGSize(width: 171.scale, height: 175.scale)
        
        let view = AddItemToWardrobeCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(vertical: 20.scale, horizontal: 16.scale)
        view.setContentOffset(CGPoint(x: 0, y: -20.scale), animated: false)
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
        view.layer.cornerRadius = 3.scale
        view.backgroundColor = Appearance.main100
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
