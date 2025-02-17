//
//  WardrobeView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 15.02.2025.
//

import UIKit

final class WardrobeView: UIView {
    lazy var headerView = makeHeaderView()
    lazy var tabsView = makeTabsView()
    lazy var container = makeContainer()
    
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
private extension WardrobeView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension WardrobeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10.scale),
            headerView.heightAnchor.constraint(equalToConstant: 142.scale)
        ])
        
        NSLayoutConstraint.activate([
            tabsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabsView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30.scale),
            tabsView.heightAnchor.constraint(equalToConstant: 37.scale)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: tabsView.bottomAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WardrobeView {
    func makeHeaderView() -> WardrobeHeaderView {
        let view = WardrobeHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTabsView() -> WardrobeTabsView {
        let view = WardrobeTabsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
