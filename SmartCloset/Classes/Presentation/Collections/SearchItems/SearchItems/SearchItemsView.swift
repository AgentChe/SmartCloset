//
//  SearchItemsView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 01.02.2025.
//

import UIKit

final class SearchItemsView: UIView {
    lazy var inputField = makeInputView()
    lazy var filterButton = makeFilterButton()
    
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
private extension SearchItemsView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension SearchItemsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            inputField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            inputField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -69.scale),
            inputField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            filterButton.leadingAnchor.constraint(equalTo: inputField.trailingAnchor, constant: 10.scale),
            filterButton.topAnchor.constraint(equalTo: inputField.topAnchor),
            filterButton.bottomAnchor.constraint(equalTo: inputField.bottomAnchor),
            filterButton.heightAnchor.constraint(equalTo: filterButton.widthAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SearchItemsView {
    func makeInputView() -> SearchItemsInputView {
        let view = SearchItemsInputView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFilterButton() -> SearchItemsFilterButton {
        let view = SearchItemsFilterButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
