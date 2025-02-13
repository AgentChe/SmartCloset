//
//  AITWCategoriesView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 13.02.2025.
//

import UIKit
import RxCocoa

final class AITWCategoriesView: UIView {
    lazy var topsButton = makeItemButton(category: .tops)
    lazy var bottomsButton = makeItemButton(category: .bottoms)
    lazy var shoesButton = makeItemButton(category: .shoes)
    lazy var bagsButton = makeItemButton(category: .bags)
    lazy var accessoriesButton = makeItemButton(category: .accessories)
    
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
extension AITWCategoriesView {
    func setup(category: ItemCategory) {
        topsButton.marked = category == topsButton.category
        bottomsButton.marked = category == bottomsButton.category
        shoesButton.marked = category == shoesButton.category
        bagsButton.marked = category == bagsButton.category
        accessoriesButton.marked = category == accessoriesButton.category
    }
    
    var didSelect: Signal<ItemCategory> {
        Signal<ItemCategory>
            .merge(
                topsButton.rx.tap
                    .compactMap { [weak self] in self?.topsButton.category }
                    .asSignal(onErrorSignalWith: .never()),
                bottomsButton.rx.tap
                    .compactMap { [weak self] in self?.bottomsButton.category }
                    .asSignal(onErrorSignalWith: .never()),
                shoesButton.rx.tap
                    .compactMap { [weak self] in self?.shoesButton.category }
                    .asSignal(onErrorSignalWith: .never()),
                bagsButton.rx.tap
                    .compactMap { [weak self] in self?.bagsButton.category }
                    .asSignal(onErrorSignalWith: .never()),
                accessoriesButton.rx.tap
                    .compactMap { [weak self] in self?.accessoriesButton.category }
                    .asSignal(onErrorSignalWith: .never())
            )
            .distinctUntilChanged()
    }
}

// MARK: Private
private extension AITWCategoriesView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension AITWCategoriesView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            topsButton.widthAnchor.constraint(equalTo: bottomsButton.widthAnchor),
            topsButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            topsButton.topAnchor.constraint(equalTo: topAnchor),
            topsButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomsButton.widthAnchor.constraint(equalTo: shoesButton.widthAnchor),
            bottomsButton.leadingAnchor.constraint(equalTo: topsButton.trailingAnchor, constant: 19.scale),
            bottomsButton.topAnchor.constraint(equalTo: topAnchor),
            bottomsButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            shoesButton.widthAnchor.constraint(equalTo: bagsButton.widthAnchor),
            shoesButton.leadingAnchor.constraint(equalTo: bottomsButton.trailingAnchor, constant: 19.scale),
            shoesButton.topAnchor.constraint(equalTo: topAnchor),
            shoesButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bagsButton.widthAnchor.constraint(equalTo: accessoriesButton.widthAnchor),
            bagsButton.leadingAnchor.constraint(equalTo: shoesButton.trailingAnchor, constant: 19.scale),
            bagsButton.topAnchor.constraint(equalTo: topAnchor),
            bagsButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            accessoriesButton.leadingAnchor.constraint(equalTo: bagsButton.trailingAnchor, constant: 19.scale),
            accessoriesButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            accessoriesButton.topAnchor.constraint(equalTo: topAnchor),
            accessoriesButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension AITWCategoriesView {
    func makeItemButton(category: ItemCategory) -> AITWCategoryItemButton {
        let view = AITWCategoryItemButton(category: category)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
