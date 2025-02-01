//
//  SearchItemsFilterButton.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 01.02.2025.
//

import UIKit

final class SearchItemsFilterButton: UIButton {
    lazy var iconView = makeIconView()
    lazy var countLabel = makeCountLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        setup(count: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
    }
}

// MARK: Public
extension SearchItemsFilterButton {
    func setup(count: Int) {
        iconView.image = UIImage(named: count == 0 ? "SearchItems.Filter.D" : "SearchItems.Filter.S")
        countLabel.setup(count: count)
    }
}

// MARK: Private
private extension SearchItemsFilterButton {
    func initialize() {
        backgroundColor = Appearance.main500
        layer.masksToBounds = false
    }
}

// MARK: Make constraints
private extension SearchItemsFilterButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: topAnchor, constant: -4.scale),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SearchItemsFilterButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCountLabel() -> CountLabel {
        let view = CountLabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
