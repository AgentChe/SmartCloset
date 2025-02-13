//
//  CLRView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 08.02.2025.
//

import UIKit

final class CLRView: UIView {
    lazy var itemsView = makeItemsView()
    lazy var addToWardrobeButton = makeAddToWardrobeButton()
    lazy var preloader = makePreloader()
    
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
extension CLRView {
    func activity(_ activity: Bool) {
        addToWardrobeButton.isHidden = activity
        activity ? preloader.startAnimating() : preloader.stopAnimating()
    }
}

// MARK: Private
private extension CLRView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension CLRView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            itemsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50.scale),
            itemsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50.scale),
            itemsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100.scale),
            itemsView.heightAnchor.constraint(equalTo: itemsView.widthAnchor, multiplier: 1.451)
        ])
        
        NSLayoutConstraint.activate([
            addToWardrobeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            addToWardrobeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            addToWardrobeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10.scale),
            addToWardrobeButton.heightAnchor.constraint(equalToConstant: 52.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.widthAnchor.constraint(equalToConstant: 45.scale),
            preloader.heightAnchor.constraint(equalToConstant: 45.scale),
            preloader.centerXAnchor.constraint(equalTo: addToWardrobeButton.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: addToWardrobeButton.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CLRView {
    func makeItemsView() -> LookItemsView {
        let view = LookItemsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAddToWardrobeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.bold(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("CLR.AddToWardrobe".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main100
        view.layer.cornerRadius = 3.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.color = Appearance.main100
        view.hidesWhenStopped = true
        view.stopAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
