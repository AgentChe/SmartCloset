//
//  CanvasItemCategoryButton.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 06.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CanvasItemCategoryButton: UIButton {
    lazy var container = makeContainer()
    lazy var addIconView = makeAddIconView()
    lazy var label = makeLabel()
    
    let itemCategory: ItemCategory
    
    init(itemCategory: ItemCategory) {
        self.itemCategory = itemCategory
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CanvasItemCategoryButton {
    var didTap: Signal<ItemCategory> {
        rx.tap.asSignal()
            .compactMap { [weak self] in self?.itemCategory }
    }
}

// MARK: Private
private extension CanvasItemCategoryButton {
    func initialize() {
        backgroundColor = Appearance.main400.withAlphaComponent(0.5)
        layer.cornerRadius = 8.scale
    }
}

// MARK: Make constraints
private extension CanvasItemCategoryButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addIconView.widthAnchor.constraint(equalToConstant: 32.scale),
            addIconView.heightAnchor.constraint(equalToConstant: 32.scale),
            addIconView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            addIconView.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 37.scale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CanvasItemCategoryButton {
    func makeContainer() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAddIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Canvas.Add")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.regular(size: 16.scale))
            .lineHeight(22.scale)
        
        let name = ItemCategory.DefaultLocalized().name(category: itemCategory)
        
        let view = UILabel()
        view.attributedText = name.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
