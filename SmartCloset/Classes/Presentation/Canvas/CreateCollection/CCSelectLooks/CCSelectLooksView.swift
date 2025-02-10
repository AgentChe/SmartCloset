//
//  CCSelectLooksView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 09.02.2025.
//

import UIKit

final class CCSelectLooksView: UIView {
    lazy var attachmentView = makeAttachmentView()
    lazy var favoriteSwitch = makeFavoriteSwitch()
    lazy var collectionView = makeCollectionView()
    lazy var centerPreloader = makePreloader()
    lazy var collectionPreloader = makePreloader()
    lazy var continueButton = makeContinueButton()
    lazy var emptyView = makeEmptyView()
    
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
extension CCSelectLooksView {
    func setup(continueEnable: Bool) {
        continueButton.isEnabled = continueEnable
        continueButton.backgroundColor = continueEnable ? Appearance.main100 : Appearance.main400
    }
}

// MARK: Private
private extension CCSelectLooksView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension CCSelectLooksView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            attachmentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            attachmentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            attachmentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.scale),
            attachmentView.heightAnchor.constraint(equalToConstant: 46.scale)
        ])
        
        NSLayoutConstraint.activate([
            favoriteSwitch.leadingAnchor.constraint(equalTo: leadingAnchor),
            favoriteSwitch.trailingAnchor.constraint(equalTo: trailingAnchor),
            favoriteSwitch.topAnchor.constraint(equalTo: attachmentView.bottomAnchor, constant: 20.scale),
            favoriteSwitch.heightAnchor.constraint(equalToConstant: 44.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: favoriteSwitch.bottomAnchor, constant: 1.scale),
            collectionView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -1.scale)
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
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 52.scale)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: favoriteSwitch.bottomAnchor),
            emptyView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CCSelectLooksView {
    func makeAttachmentView() -> CCSLAttachmentView {
        let view = CCSLAttachmentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFavoriteSwitch() -> CCSLFavoriteSwitch {
        let view = CCSLFavoriteSwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> CCSLLooksCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20.scale
        layout.minimumInteritemSpacing = 12.scale
        layout.itemSize = CGSize(width: 171.scale, height: 175.scale)
        
        let view = CCSLLooksCollectionView(frame: .zero, collectionViewLayout: layout)
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
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.bold(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main100
        view.layer.cornerRadius = 3.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmptyView() -> CCSLEmptyView {
        let view = CCSLEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
