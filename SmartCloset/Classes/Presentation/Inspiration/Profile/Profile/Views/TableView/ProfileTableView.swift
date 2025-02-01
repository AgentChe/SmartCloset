//
//  ProfileTableView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileTableView: UITableView {
    private lazy var elements = [ProfileTableElement]()
    
    private lazy var didSelectTrigger = PublishRelay<ProfileTableElement>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ProfileTableView {
    func setup(elements: [ProfileTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<ProfileTableElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension ProfileTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .avatar(let url):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ProfileAvatarCell.self), for: indexPath) as! ProfileAvatarCell
            cell.setup(url: url)
            return cell
        case .name(let name):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ProfileFieldCell.self), for: indexPath) as! ProfileFieldCell
            cell.setup(name: name)
            return cell
        case .size(let size):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ProfileFieldCell.self), for: indexPath) as! ProfileFieldCell
            cell.setup(size: size)
            return cell
        case .gender(let gender):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ProfileFieldCell.self), for: indexPath) as! ProfileFieldCell
            cell.setup(gender: gender)
            return cell
        case .height(let height):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ProfileFieldCell.self), for: indexPath) as! ProfileFieldCell
            cell.setup(height: height)
            return cell
        case .occasions(let occasions):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ProfileFieldCell.self), for: indexPath) as! ProfileFieldCell
            cell.setup(occasions: occasions)
            return cell
        case .season(let season):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ProfileFieldCell.self), for: indexPath) as! ProfileFieldCell
            cell.setup(season: season)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension ProfileTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .avatar:
            return 162.scale
        default:
            return 56.scale
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension ProfileTableView {
    func initialize() {
        register(ProfileAvatarCell.self, forCellReuseIdentifier: String(describing: ProfileAvatarCell.self))
        register(ProfileFieldCell.self, forCellReuseIdentifier: String(describing: ProfileFieldCell.self))
        
        dataSource = self
        delegate = self
    }
}
