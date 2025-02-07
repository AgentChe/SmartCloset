//
//  SIFCLCollectionCell.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 06.02.2025.
//

import UIKit
import Kingfisher

final class SIFCLCollectionCell: UICollectionViewCell {
    lazy var imageView = makeImageView()
    lazy var checkedView = makeCheckedView()
    
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
extension SIFCLCollectionCell {
    func setup(element: SIFCLCollectionElement) {
        imageView.kf.setImage(with: element.item.image)
        
        checkedView.isHidden = !element.selected
        
        contentView.layer.borderColor = element.selected ? Appearance.main200.cgColor : Appearance.main500.cgColor
    }
}

// MARK: Private
private extension SIFCLCollectionCell {
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
private extension SIFCLCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.scale),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.scale),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.scale),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            checkedView.widthAnchor.constraint(equalToConstant: 24.scale),
            checkedView.heightAnchor.constraint(equalToConstant: 24.scale),
            checkedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13.scale),
            checkedView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SIFCLCollectionCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeCheckedView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "SIFCL.Checked")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
