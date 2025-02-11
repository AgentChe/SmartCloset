//
//  ECCDLookView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 11.02.2025.
//

import UIKit
import Kingfisher

final class ECCDLookView: UIView {
    lazy var topView = makeImageView()
    lazy var bottomView = makeImageView()
    lazy var shoesView = makeImageView()
    lazy var bagsView = makeImageView()
    lazy var accessoriesView = makeImageView()
    
    private let look: Look
    
    init(look: Look) {
        self.look = look
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ECCDLookView {
    func initialize() {
        backgroundColor = Appearance.mono200
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
        layer.borderWidth = 1.5.scale
        layer.borderColor = Appearance.main500.cgColor
        
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

// MARK: Make constraints
private extension ECCDLookView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            topView.widthAnchor.constraint(equalToConstant: 42.scale),
            topView.heightAnchor.constraint(equalToConstant: 42.scale),
            topView.topAnchor.constraint(equalTo: topAnchor, constant: 7.scale),
            topView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23.scale)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.widthAnchor.constraint(equalToConstant: 48.scale),
            bottomView.heightAnchor.constraint(equalToConstant: 64.scale),
            bottomView.topAnchor.constraint(equalTo: topAnchor, constant: 54.scale),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23.scale)
        ])
        
        NSLayoutConstraint.activate([
            shoesView.widthAnchor.constraint(equalToConstant: 35.scale),
            shoesView.heightAnchor.constraint(equalToConstant: 35.scale),
            shoesView.topAnchor.constraint(equalTo: topAnchor, constant: 83.scale),
            shoesView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 61.scale)
        ])
        
        NSLayoutConstraint.activate([
            bagsView.widthAnchor.constraint(equalToConstant: 35.scale),
            bagsView.heightAnchor.constraint(equalToConstant: 35.scale),
            bagsView.topAnchor.constraint(equalTo: topAnchor, constant: 43.scale),
            bagsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 63.scale)
        ])
        
        NSLayoutConstraint.activate([
            accessoriesView.widthAnchor.constraint(equalToConstant: 35.scale),
            accessoriesView.heightAnchor.constraint(equalToConstant: 35.scale),
            accessoriesView.topAnchor.constraint(equalTo: topAnchor, constant: 7.scale),
            accessoriesView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 65.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ECCDLookView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
