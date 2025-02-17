//
//  EditCollectionView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 10.02.2025.
//

import UIKit

final class EditCollectionView: UIView {
    lazy var textField = makeTextField()
    lazy var collectionView = makeCollectionView()
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

// MARK: Public
extension EditCollectionView {
    func activity(_ activity: Bool) {
        saveButton.isHidden = activity
        activity ? preloader.startAnimating() : preloader.stopAnimating()
    }
    
    func canSave(_ canSave: Bool) {
        saveButton.isEnabled = canSave
        saveButton.backgroundColor = canSave ? Appearance.main100 : Appearance.main400
    }
}

// MARK: UITextFieldDelegate
extension EditCollectionView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

// MARK: Private
private extension EditCollectionView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension EditCollectionView {
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
            collectionView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -1.scale)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            saveButton.heightAnchor.constraint(equalToConstant: 52.scale),
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24.scale)
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
private extension EditCollectionView {
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
    
    func makeCollectionView() -> ECCollectionView {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20.scale
        layout.minimumInteritemSpacing = 12.scale
        
        let view = ECCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(t: 20.scale, b: 20.scale)
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
        view.backgroundColor = Appearance.main100
        view.setAttributedTitle("Save".localized.attributed(with: attrs), for: .normal)
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
