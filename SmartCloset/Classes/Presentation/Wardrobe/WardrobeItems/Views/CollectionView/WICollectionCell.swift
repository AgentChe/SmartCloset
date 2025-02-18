//
//  WICollectionCell.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 18.02.2025.
//

import UIKit
import Kingfisher

final class WICollectionCell: UICollectionViewCell {
    var didTapFavorite: (() -> Void)?
    
    lazy var imageView = makeItemImageView()
    lazy var favoriteButton = makeFavoriteButton()
    
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
extension WICollectionCell {
    func setup(element: WICollectionElement) {
        imageView.kf.setImage(with: element.item.image)
        
        let favoriteIcon = UIImage(named: element.favorite ? "Wardrobe.Item.Favorite.T" : "Wardrobe.Item.Favorite.F")
        favoriteButton.setImage(favoriteIcon, for: .normal)
    }
}

// MARK: Private
private extension WICollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        
        contentView.backgroundColor = Appearance.mono200
        contentView.layer.cornerRadius = 10.scale
        contentView.layer.borderWidth = 1.5.scale
        contentView.layer.borderColor = Appearance.main500.cgColor
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
    
    @objc
    func favoriteTapped() {
        didTapFavorite?()
    }
}

// MARK: Make constraints
private extension WICollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.scale),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.scale),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.scale),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            favoriteButton.widthAnchor.constraint(equalToConstant: 24.scale),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24.scale),
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.scale),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WICollectionCell {
    func makeItemImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeFavoriteButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
