//
//  LookItemsView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 05.02.2025.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

final class LookItemsView: UIView {
    lazy var topsView = makeImageView()
    lazy var bottomsView = makeImageView()
    lazy var shoesView = makeImageView()
    lazy var bagsView = makeImageView()
    lazy var accessoriesView = makeImageView()
    
    private var look: Look?
    
    private lazy var didTapItemTrigger = PublishRelay<Item>()
    
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
extension LookItemsView {
    func setup(look: Look) {
        self.look = look
        
        [
            topsView,
            bottomsView,
            shoesView,
            bagsView,
            accessoriesView
        ].forEach { view in
            view.kf.cancelDownloadTask()
            view.image = nil
        }
        
        topsView.isHidden = look.top == nil
        bottomsView.isHidden = look.bottom == nil
        shoesView.isHidden = look.shoes == nil
        bagsView.isHidden = look.bags == nil
        accessoriesView.isHidden = look.accessories == nil
        
        topsView.kf.setImage(with: look.top?.image)
        bottomsView.kf.setImage(with: look.bottom?.image)
        shoesView.kf.setImage(with: look.shoes?.image)
        bagsView.kf.setImage(with: look.bags?.image)
        accessoriesView.kf.setImage(with: look.accessories?.image)
    }
    
    var didTapItem: Signal<Item> {
        didTapItemTrigger.asSignal()
    }
}

// MARK: Private
private extension LookItemsView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
    
    @objc
    func tapped(gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        
        if view === topsView, let item = look?.top {
            didTapItemTrigger.accept(item)
        } else if view === bottomsView, let item = look?.bottom {
            didTapItemTrigger.accept(item)
        } else if view === shoesView, let item = look?.shoes {
            didTapItemTrigger.accept(item)
        } else if view === bagsView, let item = look?.bags {
            didTapItemTrigger.accept(item)
        } else if view === accessoriesView, let item = look?.accessories {
            didTapItemTrigger.accept(item)
        }
    }
}

// MARK: Make constraints
private extension LookItemsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            topsView.widthAnchor.constraint(equalTo: topsView.heightAnchor),
            topsView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.38),
            topsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topsView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomsView.widthAnchor.constraint(equalTo: bottomsView.heightAnchor, multiplier: 0.75),
            bottomsView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.57),
            bottomsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomsView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            shoesView.widthAnchor.constraint(equalTo: shoesView.heightAnchor),
            shoesView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.308),
            shoesView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9.scale),
            shoesView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6.scale)
        ])
        
        NSLayoutConstraint.activate([
            bagsView.widthAnchor.constraint(equalTo: bagsView.heightAnchor),
            bagsView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.308),
            bagsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7.scale),
            bagsView.topAnchor.constraint(equalTo: accessoriesView.bottomAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            accessoriesView.widthAnchor.constraint(equalTo: accessoriesView.heightAnchor),
            accessoriesView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.308),
            accessoriesView.trailingAnchor.constraint(equalTo: trailingAnchor),
            accessoriesView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension LookItemsView {
    func makeImageView() -> UIImageView {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapped(gesture:)))
        
        let view = UIImageView()
        view.addGestureRecognizer(gesture)
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
