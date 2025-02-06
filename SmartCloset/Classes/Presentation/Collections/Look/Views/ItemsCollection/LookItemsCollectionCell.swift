//
//  LookItemsCollectionCell.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 05.02.2025.
//

import UIKit
import Kingfisher

final class LookItemsCollectionCell: UICollectionViewCell {
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
extension LookItemsCollectionCell {
    func setup(item: Item) {
        imageView.kf.setImage(with: item.image)
    }
}

// MARK: Private
private extension LookItemsCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        
        contentView.backgroundColor = Appearance.main500
        contentView.layer.cornerRadius = 10.scale
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension LookItemsCollectionCell {
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
private extension LookItemsCollectionCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
