//
//  ECCDCollectionLookView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 11.02.2025.
//

import UIKit
import Kingfisher

final class ECCDCollectionLookView: UIView {
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
private extension ECCDCollectionLookView {
    func initialize() {
        backgroundColor = Appearance.mono200
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
        
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
private extension ECCDCollectionLookView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            topView.widthAnchor.constraint(equalToConstant: 22.scale),
            topView.heightAnchor.constraint(equalToConstant: 22.scale),
            topView.topAnchor.constraint(equalTo: topAnchor, constant: 3.scale),
            topView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.widthAnchor.constraint(equalToConstant: 25.scale),
            bottomView.heightAnchor.constraint(equalToConstant: 34.scale),
            bottomView.topAnchor.constraint(equalTo: topAnchor, constant: 27.scale),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            shoesView.widthAnchor.constraint(equalToConstant: 19.scale),
            shoesView.heightAnchor.constraint(equalToConstant: 19.scale),
            shoesView.topAnchor.constraint(equalTo: topAnchor, constant: 43.scale),
            shoesView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28.scale)
        ])
        
        NSLayoutConstraint.activate([
            bagsView.widthAnchor.constraint(equalToConstant: 19.scale),
            bagsView.heightAnchor.constraint(equalToConstant: 19.scale),
            bagsView.topAnchor.constraint(equalTo: topAnchor, constant: 22.scale),
            bagsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 29.scale)
        ])
        
        NSLayoutConstraint.activate([
            accessoriesView.widthAnchor.constraint(equalToConstant: 19.scale),
            accessoriesView.heightAnchor.constraint(equalToConstant: 19.scale),
            accessoriesView.topAnchor.constraint(equalTo: topAnchor, constant: 3.scale),
            accessoriesView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ECCDCollectionLookView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
