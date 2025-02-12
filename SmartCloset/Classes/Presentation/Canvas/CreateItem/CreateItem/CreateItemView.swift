//
//  CreateItemView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 11.02.2025.
//

import UIKit

final class CreateItemView: UIView {
    lazy var tableView = makeTableView()
    lazy var saveButton = makeSaveButton()
    lazy var changePhotoButton = makeChangePhotoButton()
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
extension CreateItemView {
    func canSave(_ canSave: Bool) {
        saveButton.isEnabled = canSave
        saveButton.backgroundColor = canSave ? Appearance.main100 : Appearance.main400
    }
    
    func activity(_ activity: Bool) {
        saveButton.isHidden = activity
        changePhotoButton.isHidden = activity
        activity ? preloader.startAnimating() : preloader.stopAnimating()
    }
}

// MARK: Private
private extension CreateItemView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension CreateItemView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            saveButton.heightAnchor.constraint(equalToConstant: 52.scale),
            saveButton.bottomAnchor.constraint(equalTo: changePhotoButton.topAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            changePhotoButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            changePhotoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            changePhotoButton.heightAnchor.constraint(equalToConstant: 52.scale),
            changePhotoButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.widthAnchor.constraint(equalToConstant: 45.scale),
            preloader.heightAnchor.constraint(equalToConstant: 45.scale),
            preloader.centerXAnchor.constraint(equalTo: changePhotoButton.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: changePhotoButton.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CreateItemView {
    func makeTableView() -> CITableView {
        let view = CITableView()
        view.contentInset = UIEdgeInsets()
        view.setContentOffset(CGPoint.zero, animated: false)
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor.clear
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
    
    func makeChangePhotoButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.bold(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("CreateItem.ChangePhoto".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 3.scale
        view.backgroundColor = Appearance.main400
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
