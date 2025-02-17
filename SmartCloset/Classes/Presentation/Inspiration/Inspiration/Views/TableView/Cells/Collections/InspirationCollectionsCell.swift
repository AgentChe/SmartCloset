//
//  InspirationCollectionsCell.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 04.02.2025.
//

import UIKit

final class InspirationCollectionsCell: UITableViewCell {
    var didTapCollections: (() -> Void)?
    var didSelectItemCategory: ((ItemCategory) -> Void)?
    
    lazy var collectionsButton = makeCollectionsButton()
    lazy var leftItemCategoryButton = makeItemCategoryButton()
    lazy var rightItemCategoryButton = makeItemCategoryButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension InspirationCollectionsCell {
    func setup(element: InspirationTableCollectionElement) {
        collectionsButton.setup(gender: element.gender, season: element.season)
        leftItemCategoryButton.setup(category: element.leftItemCategory, season: element.season)
        rightItemCategoryButton.setup(category: element.rightItemCategory, season: element.season)
    }
}

// MARK: Private
private extension InspirationCollectionsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func collectionsTapped() {
        didTapCollections?()
    }
    
    @objc
    func didTapCategory(sender: UIButton) {
        guard let categoryButton = sender as? InspirationItemCategoryButton, let category = categoryButton.itemCategory else { return }
        didSelectItemCategory?(category)
    }
}

// MARK: Make constraints
private extension InspirationCollectionsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            collectionsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            collectionsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            collectionsButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale),
            collectionsButton.heightAnchor.constraint(equalToConstant: 180.scale)
        ])
        
        NSLayoutConstraint.activate([
            leftItemCategoryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            leftItemCategoryButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            leftItemCategoryButton.widthAnchor.constraint(equalToConstant: 172.scale),
            leftItemCategoryButton.heightAnchor.constraint(equalToConstant: 130.scale)
        ])
        
        NSLayoutConstraint.activate([
            rightItemCategoryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            rightItemCategoryButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            rightItemCategoryButton.widthAnchor.constraint(equalToConstant: 172.scale),
            rightItemCategoryButton.heightAnchor.constraint(equalToConstant: 130.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension InspirationCollectionsCell {
    func makeCollectionsButton() -> InspirationCollectionButton {
        let view = InspirationCollectionButton()
        view.addTarget(self, action: #selector(collectionsTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeItemCategoryButton() -> InspirationItemCategoryButton {
        let view = InspirationItemCategoryButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didTapCategory(sender:)), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
