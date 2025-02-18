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
    lazy var curtainSelectSheetView = makeCurtainTabSelectSheetView()
    lazy var addTabSelectSheetView = makeAddTabSelectSheetView()
    
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
extension WardrobeView {
    func addTab(mode: WardrobeAddTabSelectSheetView.Mode) {
        addTabSelectSheetView.setup(mode: mode)
        curtainSelectSheet(mode: mode)
    }
}

// MARK: Private
private extension WardrobeView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
    
    func curtainSelectSheet(mode: WardrobeAddTabSelectSheetView.Mode) {
        switch mode {
        case .on:
            curtainSelectSheetView.isHidden = false
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.curtainSelectSheetView.alpha = 0.4
            })
        case .off:
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.curtainSelectSheetView.alpha = 0
            }, completion: { [weak self] complete in
                self?.curtainSelectSheetView.isHidden = true
            })
        }
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
        
        NSLayoutConstraint.activate([
            curtainSelectSheetView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            curtainSelectSheetView.heightAnchor.constraint(equalToConstant: 5000),
            curtainSelectSheetView.centerXAnchor.constraint(equalTo: centerXAnchor),
            curtainSelectSheetView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addTabSelectSheetView.widthAnchor.constraint(equalToConstant: 169.scale),
            addTabSelectSheetView.heightAnchor.constraint(equalToConstant: 234.scale),
            addTabSelectSheetView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            addTabSelectSheetView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale)
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
    
    func makeCurtainTabSelectSheetView() -> UIView {
        let view = UIView()
        view.layer.masksToBounds = false
        view.isUserInteractionEnabled = false 
        view.isHidden = true
        view.backgroundColor = UIColor.black
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAddTabSelectSheetView() -> WardrobeAddTabSelectSheetView {
        let view = WardrobeAddTabSelectSheetView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
