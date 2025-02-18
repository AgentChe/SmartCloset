//
//  WardrobeAddTabSelectSheetView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 18.02.2025.
//

import UIKit

final class WardrobeAddTabSelectSheetView: UIView {
    enum Mode {
        case on, off
    }
    
    lazy var tabButtonsContainer = makeTabButtonsContainer()
    lazy var itemButton = makeTabButton(title: "Wardrobe.Add.Item".localized)
    lazy var lookButton = makeTabButton(title: "Wardrobe.Add.Look".localized)
    lazy var collectionButton = makeTabButton(title: "Wardrobe.Add.Collection".localized)
    lazy var addButton = makeAddButton()
    
    private var mode: Mode?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let mode = mode ?? .off
        
        switch mode {
        case .on:
            return super.point(inside: point, with: event)
        case .off:
            return addButton.frame.contains(point)
        }
    }
}

// MARK: Public
extension WardrobeAddTabSelectSheetView {
    func setup(mode: Mode) {
        self.mode = mode
        
        hiddenButtons(mode: mode)
        rotate(mode: mode)
    }
}

// MARK: Private
private extension WardrobeAddTabSelectSheetView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func hiddenButtons(mode: Mode) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.tabButtonsContainer.alpha = {
                switch mode {
                case .on:
                    return 1
                case .off:
                    return 0
                }
            }()
        })
    }
    
    func rotate(mode: Mode) {
        let isRotate: Bool = {
            switch mode {
            case .on:
                return true
            case .off:
                return false
            }
        }()
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.addButton.transform = isRotate ? CGAffineTransform(rotationAngle: .pi / 4) : CGAffineTransform.identity
        })
    }
}

// MARK: Make constraints
private extension WardrobeAddTabSelectSheetView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tabButtonsContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabButtonsContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabButtonsContainer.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            itemButton.widthAnchor.constraint(equalToConstant: 122.scale),
            itemButton.heightAnchor.constraint(equalToConstant: 42.scale),
            itemButton.trailingAnchor.constraint(equalTo: tabButtonsContainer.trailingAnchor),
            itemButton.topAnchor.constraint(equalTo: tabButtonsContainer.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            lookButton.widthAnchor.constraint(equalToConstant: 130.scale),
            lookButton.heightAnchor.constraint(equalToConstant: 42.scale),
            lookButton.trailingAnchor.constraint(equalTo: tabButtonsContainer.trailingAnchor),
            lookButton.topAnchor.constraint(equalTo: itemButton.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionButton.widthAnchor.constraint(equalToConstant: 169.scale),
            collectionButton.heightAnchor.constraint(equalToConstant: 42.scale),
            collectionButton.trailingAnchor.constraint(equalTo: tabButtonsContainer.trailingAnchor),
            collectionButton.topAnchor.constraint(equalTo: lookButton.bottomAnchor, constant: 12.scale),
            collectionButton.bottomAnchor.constraint(equalTo: tabButtonsContainer.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 68.scale),
            addButton.heightAnchor.constraint(equalToConstant: 68.scale),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WardrobeAddTabSelectSheetView {
    func makeTabButtonsContainer() -> UIView {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTabButton(title: String) -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.regular(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle(title.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.mono200
        view.layer.cornerRadius = 4.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        tabButtonsContainer.addSubview(view)
        return view
    }
    
    func makeAddButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Wardrobe.AddObject"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
