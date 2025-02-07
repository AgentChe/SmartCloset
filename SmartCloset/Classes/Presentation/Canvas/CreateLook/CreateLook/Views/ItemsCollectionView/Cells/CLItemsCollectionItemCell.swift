//
//  CLItemsCollectionItemCell.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 07.02.2025.
//

import UIKit
import Kingfisher

final class CLItemsCollectionItemCell: UICollectionViewCell {
    lazy var imageView = makeImageView()
    
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
extension CLItemsCollectionItemCell {
    func setup(element: CLItemsCollectionItemElement) {
        imageView.kf.setImage(with: element.item.image)
        
        contentView.backgroundColor = element.selected ? Appearance.main500 : Appearance.mono200
    }
}

// MARK: Private
private extension CLItemsCollectionItemCell {
    func initialize() {
        backgroundColor = UIColor.clear
        
        contentView.layer.borderWidth = 1.5.scale
        contentView.layer.borderColor = Appearance.main500.cgColor
        contentView.layer.cornerRadius = 8.scale
        contentView.layer.masksToBounds = true
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension CLItemsCollectionItemCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.scale),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.scale),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.scale),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CLItemsCollectionItemCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
