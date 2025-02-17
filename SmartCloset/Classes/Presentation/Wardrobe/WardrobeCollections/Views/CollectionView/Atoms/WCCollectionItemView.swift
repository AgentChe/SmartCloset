//
//  WCCollectionItemView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 17.02.2025.
//

import UIKit
import Kingfisher

final class WCCollectionItemView: UIView {
    lazy var topView = makeImageView()
    lazy var bottomView = makeImageView()
    lazy var shoesView = makeImageView()
    lazy var bagsView = makeImageView()
    lazy var accessoriesView = makeImageView()
    
    var look: Look?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WCCollectionItemView {
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
private extension WCCollectionItemView {
    func initialize() {
        backgroundColor = Appearance.mono200
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension WCCollectionItemView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            topView.widthAnchor.constraint(equalToConstant: 58.scale),
            topView.heightAnchor.constraint(equalToConstant: 58.scale),
            topView.topAnchor.constraint(equalTo: topAnchor, constant: 10.scale),
            topView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.widthAnchor.constraint(equalToConstant: 65.scale),
            bottomView.heightAnchor.constraint(equalToConstant: 88.scale),
            bottomView.topAnchor.constraint(equalTo: topAnchor, constant: 74.scale),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            shoesView.widthAnchor.constraint(equalToConstant: 48.scale),
            shoesView.heightAnchor.constraint(equalToConstant: 48.scale),
            shoesView.topAnchor.constraint(equalTo: topAnchor, constant: 114.scale),
            shoesView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 84.scale)
        ])
        
        NSLayoutConstraint.activate([
            bagsView.widthAnchor.constraint(equalToConstant: 48.scale),
            bagsView.heightAnchor.constraint(equalToConstant: 48.scale),
            bagsView.topAnchor.constraint(equalTo: topAnchor, constant: 50.scale),
            bagsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 77.scale)
        ])
        
        NSLayoutConstraint.activate([
            accessoriesView.widthAnchor.constraint(equalToConstant: 48.scale),
            accessoriesView.heightAnchor.constraint(equalToConstant: 48.scale),
            accessoriesView.topAnchor.constraint(equalTo: topAnchor, constant: 10.scale),
            accessoriesView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 90.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WCCollectionItemView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
