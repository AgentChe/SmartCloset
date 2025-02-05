//
//  IRCollectionLookCell.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 05.02.2025.
//

import UIKit
import Kingfisher

final class IRCollectionLookCell: UICollectionViewCell {
    lazy var topView = makeImageView()
    lazy var bottomView = makeImageView()
    lazy var shoesView = makeImageView()
    lazy var bagsView = makeImageView()
    lazy var accessoriesView = makeImageView()
    
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
        
        topView.kf.cancelDownloadTask()
        bottomView.kf.cancelDownloadTask()
        shoesView.kf.cancelDownloadTask()
        bagsView.kf.cancelDownloadTask()
        accessoriesView.kf.cancelDownloadTask()
    }
}

// MARK: Public
extension IRCollectionLookCell {
    func setup(look: Look) {
        topView.isHidden = look.top == nil
        bottomView.isHidden = look.bottom == nil
        shoesView.isHidden = look.shoes == nil
        bagsView.isHidden = look.bags == nil
        accessoriesView.isHidden = look.accessories == nil
        
        topView.kf.setImage(with: look.top?.image)
        bottomView.kf.setImage(with: look.bottom?.image)
        shoesView.kf.setImage(with: look.shoes?.image)
        bagsView.kf.setImage(with: look.bags?.image)
        accessoriesView.kf.setImage(with: look.accessories?.image)
    }
}

// MARK: Private
private extension IRCollectionLookCell {
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
private extension IRCollectionLookCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            topView.widthAnchor.constraint(equalToConstant: 40.scale),
            topView.heightAnchor.constraint(equalToConstant: 40.scale),
            topView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.scale),
            topView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26.scale)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.widthAnchor.constraint(equalToConstant: 44.scale),
            bottomView.heightAnchor.constraint(equalToConstant: 58.scale),
            bottomView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 56.scale),
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26.scale)
        ])
        
        NSLayoutConstraint.activate([
            shoesView.widthAnchor.constraint(equalToConstant: 32.scale),
            shoesView.heightAnchor.constraint(equalToConstant: 32.scale),
            shoesView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 82.scale),
            shoesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 61.scale)
        ])
        
        NSLayoutConstraint.activate([
            bagsView.widthAnchor.constraint(equalToConstant: 32.scale),
            bagsView.heightAnchor.constraint(equalToConstant: 32.scale),
            bagsView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 45.scale),
            bagsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 63.scale)
        ])
        
        NSLayoutConstraint.activate([
            accessoriesView.widthAnchor.constraint(equalToConstant: 32.scale),
            accessoriesView.heightAnchor.constraint(equalToConstant: 32.scale),
            accessoriesView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11.scale),
            accessoriesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 66.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension IRCollectionLookCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
