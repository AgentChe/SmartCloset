//
//  AddItemToWardrobeCollectionCell.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 13.02.2025.
//

import UIKit
import Kingfisher

final class AddItemToWardrobeCollectionCell: UICollectionViewCell {
    lazy var imageView = makeItemImageView()
    lazy var markedView = makeMarkedView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
}

// MARK: Public
extension AddItemToWardrobeCollectionCell {
    func setup(element: AddItemToWardrobeCollectionElement) {
        imageView.kf.setImage(with: element.item.image)
        markedView.isHidden = !element.marked
        contentView.layer.borderColor = element.marked ? Appearance.main200.cgColor : Appearance.main500.cgColor
    }
}

// MARK: Private
private extension AddItemToWardrobeCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        
        contentView.backgroundColor = Appearance.mono200
        contentView.layer.cornerRadius = 10.scale
        contentView.layer.borderWidth = 1.5.scale
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension AddItemToWardrobeCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.scale),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.scale),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.scale),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            markedView.widthAnchor.constraint(equalToConstant: 24.scale),
            markedView.heightAnchor.constraint(equalToConstant: 24.scale),
            markedView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.scale),
            markedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension AddItemToWardrobeCollectionCell {
    func makeItemImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeMarkedView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "AddItemToWardrobe.Marked")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
