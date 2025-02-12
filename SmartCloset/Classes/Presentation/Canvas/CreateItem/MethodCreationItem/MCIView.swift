//
//  MCIView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 11.02.2025.
//

import UIKit

final class MCIView: UIView {
    lazy var imageView = makeImageView()
    lazy var h1Label = makeH1Label()
    lazy var h2Label = makeH2Label()
    lazy var databaseButton = makeMCIButton(method: .database)
    lazy var galleryButton = makeMCIButton(method: .gallery)
    lazy var takePhotoButton = makeMCIButton(method: .takePhoto)
    
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
private extension MCIView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraits
private extension MCIView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 136.scale),
            imageView.heightAnchor.constraint(equalToConstant: 136.scale),
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            h1Label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            h1Label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            h1Label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            h2Label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            h2Label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            h2Label.topAnchor.constraint(equalTo: h1Label.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            databaseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            databaseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            databaseButton.heightAnchor.constraint(equalToConstant: 90.scale),
            databaseButton.topAnchor.constraint(equalTo: h2Label.bottomAnchor, constant: 46.scale)
        ])
        
        NSLayoutConstraint.activate([
            galleryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            galleryButton.trailingAnchor.constraint(equalTo: takePhotoButton.leadingAnchor, constant: -16.scale),
            galleryButton.widthAnchor.constraint(equalTo: takePhotoButton.widthAnchor),
            galleryButton.heightAnchor.constraint(equalToConstant: 90.scale),
            galleryButton.topAnchor.constraint(equalTo: databaseButton.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            takePhotoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            takePhotoButton.heightAnchor.constraint(equalToConstant: 90.scale),
            takePhotoButton.topAnchor.constraint(equalTo: databaseButton.bottomAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MCIView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "MethodCreationItem.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeH1Label() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.bold(size: 22.scale))
            .lineHeight(35.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "MethodCreationItem.H1".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeH2Label() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.regular(size: 16.scale))
            .lineHeight(19.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "MethodCreationItem.H2".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeMCIButton(method: MethodCreationItem) -> MCIButton {
        let view = MCIButton(method: method)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
