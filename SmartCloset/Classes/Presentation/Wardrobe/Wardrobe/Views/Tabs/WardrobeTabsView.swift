//
//  WardrobeTabsView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 16.02.2025.
//

import UIKit
import RxCocoa

final class WardrobeTabsView: UIView {
    lazy var itemsButton = makeButton(tab: .items)
    lazy var looksButton = makeButton(tab: .looks)
    lazy var collectionsButton = makeButton(tab: .collections)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initiailize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WardrobeTabsView {
    func setup(tab: WardrobeTabItemButton.Tab) {
        itemsButton.marked = tab == .items
        looksButton.marked = tab == .looks
        collectionsButton.marked = tab == .collections
    }
    
    var didSelect: Signal<WardrobeTabItemButton.Tab> {
        Signal<WardrobeTabItemButton.Tab>
            .merge(
                itemsButton.rx.tap
                    .asSignal()
                    .compactMap { [weak self] in self?.itemsButton.tab },
                looksButton.rx.tap
                    .asSignal()
                    .compactMap { [weak self] in self?.looksButton.tab },
                collectionsButton.rx.tap
                    .asSignal()
                    .compactMap { [weak self] in self?.collectionsButton.tab }
            )
    }
}

// MARK: Private
private extension WardrobeTabsView {
    func initiailize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension WardrobeTabsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            itemsButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemsButton.trailingAnchor.constraint(equalTo: looksButton.leadingAnchor),
            itemsButton.topAnchor.constraint(equalTo: topAnchor),
            itemsButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            itemsButton.widthAnchor.constraint(equalTo: looksButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            looksButton.trailingAnchor.constraint(equalTo: collectionsButton.leadingAnchor),
            looksButton.topAnchor.constraint(equalTo: topAnchor),
            looksButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            looksButton.widthAnchor.constraint(equalTo: collectionsButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionsButton.topAnchor.constraint(equalTo: topAnchor),
            collectionsButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionsButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WardrobeTabsView {
    func makeButton(tab: WardrobeTabItemButton.Tab) -> WardrobeTabItemButton {
        let view = WardrobeTabItemButton(tab: tab)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
