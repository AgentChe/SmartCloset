//
//  CITableImageCell.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 11.02.2025.
//

import UIKit
import Kingfisher

final class CITableImageCell: UITableViewCell {
    lazy var pictureView = makeImageView()
    lazy var separator = makeSeparator()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pictureView.kf.cancelDownloadTask()
        pictureView.image = nil
    }
}

// MARK: Public
extension CITableImageCell {
    func setup(element: CITableImageElement) {
        switch element {
        case .placeholder:
            pictureView.image = UIImage(named: "CreateItem.Image.Placeholder")
        case .url(let url):
            pictureView.kf.setImage(with: url)
        }
    }
}

// MARK: Private
private extension CITableImageCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension CITableImageCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            pictureView.widthAnchor.constraint(equalToConstant: 210.scale),
            pictureView.heightAnchor.constraint(equalToConstant: 218.scale),
            pictureView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pictureView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.scale),
            separator.heightAnchor.constraint(equalToConstant: 1.5.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CITableImageCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 232, green: 232, blue: 232)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
