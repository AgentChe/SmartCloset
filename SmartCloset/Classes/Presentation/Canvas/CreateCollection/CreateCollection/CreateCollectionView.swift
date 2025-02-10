//
//  CreateCollectionView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 10.02.2025.
//

import UIKit

final class CreateCollectionView: UIView {
    lazy var textField = makeTextField()
    lazy var collectionView = makeCollectionView()
    lazy var createCollectionButton = makeCreateCollectionButton()
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

// MARK: Public
extension CreateCollectionView {
    func setup(enableCreate: Bool) {
        createCollectionButton.isEnabled = enableCreate
        createCollectionButton.backgroundColor = enableCreate ? Appearance.main100 : Appearance.main400
    }
}

// MARK: UITextFieldDelegate
extension CreateCollectionView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

// MARK: Private
private extension CreateCollectionView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension CreateCollectionView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            textField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            collectionView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 1.scale),
            collectionView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            createCollectionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            createCollectionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            createCollectionButton.heightAnchor.constraint(equalToConstant: 52.scale),
            createCollectionButton.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.widthAnchor.constraint(equalToConstant: 45.scale),
            preloader.heightAnchor.constraint(equalToConstant: 45.scale),
            preloader.centerXAnchor.constraint(equalTo: createCollectionButton.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: createCollectionButton.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CreateCollectionView {
    func makeTextField() -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.regular(size: 16.scale))
            .lineHeight(22.scale)
        
        let view = PaddingTextField()
        view.backgroundColor = Appearance.main500
        view.delegate = self
        view.returnKeyType = .done
        view.layer.cornerRadius = 8.scale
        view.layer.masksToBounds = true
        view.defaultTextAttributes = attrs.dictionary
        view.textPadding = UIEdgeInsets(vertical: 11.scale, horizontal: 16.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> CCLooksCollectionView {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20.scale
        layout.minimumInteritemSpacing = 12.scale
        layout.itemSize = CGSize(width: 171.scale, height: 175.scale)
        
        let view = CCLooksCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(t: 20.scale, b: 80.scale)
        view.setContentOffset(CGPoint(x: 0, y: -20.scale), animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCreateCollectionButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.bold(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("CreateCollection.AddToWardrobe".localized.attributed(with: attrs), for: .normal)
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
