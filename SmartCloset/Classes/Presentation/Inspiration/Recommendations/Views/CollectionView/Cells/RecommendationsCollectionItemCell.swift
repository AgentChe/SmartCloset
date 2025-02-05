//
//  RecommendationsCollectionItemCell.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 05.02.2025.
//

import UIKit
import Kingfisher

final class RecommendationsCollectionItemCell: UICollectionViewCell {
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
extension RecommendationsCollectionItemCell {
    func setup(item: Item) {
        imageView.kf.setImage(with: item.image)
    }
}

// MARK: Private
private extension RecommendationsCollectionItemCell {
    func initialize() {
        backgroundColor = UIColor.clear
        
        contentView.backgroundColor = UIColor.clear
        contentView.layer.cornerRadius = 10.scale
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = Appearance.main500.cgColor
        contentView.layer.borderWidth = 1.5.scale
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension RecommendationsCollectionItemCell {
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
private extension RecommendationsCollectionItemCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
