//
//  AvatarActionSheetView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import UIKit

final class AvatarActionSheetView: UIView {
    lazy var takePhotoButton = makeActionButton(action: .takePhoto)
    lazy var chooseFromGalleryButton = makeActionButton(action: .chooseromGallery)
    lazy var deleteButton = makeActionButton(action: .delete)
    
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
private extension AvatarActionSheetView {
    func initialize() {
        backgroundColor = Appearance.mono200
        
        deleteButton.separator.isHidden = true
    }
}

// MARK: Make constraints
private extension AvatarActionSheetView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            takePhotoButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            takePhotoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            takePhotoButton.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            chooseFromGalleryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            chooseFromGalleryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            chooseFromGalleryButton.topAnchor.constraint(equalTo: takePhotoButton.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            deleteButton.topAnchor.constraint(equalTo: chooseFromGalleryButton.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension AvatarActionSheetView {
    func makeActionButton(action: AvatarActionButton.Action) -> AvatarActionButton {
        let view = AvatarActionButton(action: action)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
