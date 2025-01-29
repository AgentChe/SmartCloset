//
//  TabView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import UIKit

final class TabView: UIView {
    enum Tab {
        case inspiration, canvas, wardrobe
    }
    
    lazy var separator = makeSeparator()
    lazy var inspirationButton = makeButton(code: "Main.Inspiration")
    lazy var canvasButton = makeButton(code: "Main.Canvas")
    lazy var wardrobeButton = makeButton(code: "Main.Wardrobe")
    
    var selectedTab = Tab.inspiration {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TabView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func update() {
        inspirationButton.marked = selectedTab == .inspiration
        canvasButton.marked = selectedTab == .canvas
        wardrobeButton.marked = selectedTab == .wardrobe
    }
}

// MARK: Make constraints
private extension TabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.scale),
            separator.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            inspirationButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            inspirationButton.trailingAnchor.constraint(equalTo: canvasButton.leadingAnchor),
            inspirationButton.heightAnchor.constraint(equalToConstant: 64.scale),
            inspirationButton.widthAnchor.constraint(equalTo: canvasButton.widthAnchor),
            inspirationButton.topAnchor.constraint(equalTo: topAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            canvasButton.leadingAnchor.constraint(equalTo: inspirationButton.trailingAnchor),
            canvasButton.trailingAnchor.constraint(equalTo: wardrobeButton.leadingAnchor),
            canvasButton.heightAnchor.constraint(equalToConstant: 64.scale),
            canvasButton.widthAnchor.constraint(equalTo: wardrobeButton.widthAnchor),
            canvasButton.topAnchor.constraint(equalTo: topAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            wardrobeButton.leadingAnchor.constraint(equalTo: canvasButton.trailingAnchor),
            wardrobeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            wardrobeButton.heightAnchor.constraint(equalToConstant: 64.scale),
            wardrobeButton.topAnchor.constraint(equalTo: topAnchor, constant: 8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TabView {
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main400.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton(code: String) -> TabItemButton {
        let view = TabItemButton(code: code)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
