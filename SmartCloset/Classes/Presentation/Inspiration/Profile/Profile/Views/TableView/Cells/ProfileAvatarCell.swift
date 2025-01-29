//
//  ProfileAvatarCell.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import UIKit
import Kingfisher

final class ProfileAvatarCell: UITableViewCell {
    lazy var avatarView = makeAvatarView()
    lazy var editView = makeEditView()
    
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
        
        avatarView.kf.cancelDownloadTask()
        avatarView.image = nil
    }
}

// MARK: Public
extension ProfileAvatarCell {
    func setup(url: URL?) {
        guard let url else { return }
        
        avatarView.kf.setImage(with: url)
    }
}

// MARK: Private
private extension ProfileAvatarCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ProfileAvatarCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: 100.scale),
            avatarView.heightAnchor.constraint(equalToConstant: 100.scale),
            avatarView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            editView.widthAnchor.constraint(equalToConstant: 32.scale),
            editView.heightAnchor.constraint(equalToConstant: 32.scale),
            editView.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor),
            editView.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileAvatarCell {
    func makeAvatarView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = Appearance.main400
        view.layer.cornerRadius = 50.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeEditView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Profile.Edit")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
