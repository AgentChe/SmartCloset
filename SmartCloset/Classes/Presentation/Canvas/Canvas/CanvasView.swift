//
//  CanvasView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 06.02.2025.
//

import UIKit

final class CanvasView: UIView {
    lazy var headerView = makeHeaderView()
    lazy var topsButton = makeItemCategoryButton(itemCategory: .tops)
    lazy var bottomsButton = makeItemCategoryButton(itemCategory: .bottoms)
    lazy var shoesButton = makeItemCategoryButton(itemCategory: .shoes)
    lazy var bagsButton = makeItemCategoryButton(itemCategory: .bags)
    lazy var accessoriesButton = makeItemCategoryButton(itemCategory: .accessories)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CanvasView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension CanvasView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 142.scale)
        ])
        
        NSLayoutConstraint.activate([
            topsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            topsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            topsButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20.scale),
            topsButton.heightAnchor.constraint(equalTo: bottomsButton.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            bottomsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            bottomsButton.topAnchor.constraint(equalTo: topsButton.bottomAnchor, constant: 16.scale),
            bottomsButton.heightAnchor.constraint(equalTo: shoesButton.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            shoesButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            shoesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            shoesButton.topAnchor.constraint(equalTo: bottomsButton.bottomAnchor, constant: 16.scale),
            shoesButton.heightAnchor.constraint(equalTo: bagsButton.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bagsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            bagsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            bagsButton.topAnchor.constraint(equalTo: shoesButton.bottomAnchor, constant: 16.scale),
            bagsButton.heightAnchor.constraint(equalTo: accessoriesButton.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            accessoriesButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            accessoriesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            accessoriesButton.topAnchor.constraint(equalTo: bagsButton.bottomAnchor, constant: 16.scale),
            accessoriesButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -22.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CanvasView {
    func makeHeaderView() -> CanvasHeaderView {
        let view = CanvasHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeItemCategoryButton(itemCategory: ItemCategory) -> CanvasItemCategoryButton {
        let view = CanvasItemCategoryButton(itemCategory: itemCategory)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
