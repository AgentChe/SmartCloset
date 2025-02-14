//
//  ItemView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 04.02.2025.
//

import UIKit

final class ItemView: UIView {
    lazy var tableView = makeTableView()
    lazy var wardrobeButton = makeWardrobeButton()
    lazy var preloader = makePreloader()
    
    private lazy var addToWardrobeAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.bold(size: 18.scale))
    private lazy var deleteFromWardrobeAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.SofiaSans.bold(size: 18.scale))
    
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
extension ItemView {
    func wardrobe(_ wardrobe: Bool) {
        wardrobeButton.backgroundColor = wardrobe ? UIColor(integralRed: 249, green: 89, blue: 86) : Appearance.main100
        
        let attrs = wardrobe ? deleteFromWardrobeAttrs : addToWardrobeAttrs
        let title = wardrobe ? "Item.DeleteFromWarbrobe".localized : "Item.AddToWarbrobe".localized
        wardrobeButton.setAttributedTitle(title.attributed(with: attrs), for: .normal)
    }
}

// MARK: Private
private extension ItemView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension ItemView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: wardrobeButton.topAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            wardrobeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            wardrobeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            wardrobeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10.scale),
            wardrobeButton.heightAnchor.constraint(equalToConstant: 52.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.widthAnchor.constraint(equalToConstant: 45.scale),
            preloader.heightAnchor.constraint(equalToConstant: 45.scale),
            preloader.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ItemView {
    func makeTableView() -> ItemTableView {
        let view = ItemTableView()
        view.contentInset = UIEdgeInsets()
        view.setContentOffset(CGPoint.zero, animated: false)
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeWardrobeButton() -> UIButton {
        let view = UIButton()
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
