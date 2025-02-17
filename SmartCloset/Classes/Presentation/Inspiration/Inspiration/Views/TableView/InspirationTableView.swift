//
//  InspirationTableView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 04.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class InspirationTableView: UITableView {
    private lazy var elements = [InspirationTableElement]()
    
    private lazy var didSelectItemCategoryTrigger = PublishRelay<ItemCategory>()
    private lazy var didSelectItemTrigger = PublishRelay<Item>()
    private lazy var didSelectLookTrigger = PublishRelay<Look>()
    private lazy var didTapSeeAllRecommendationsTrigger = PublishRelay<Void>()
    private lazy var didTapCollectionsTrigger = PublishRelay<Void>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension InspirationTableView {
    func setup(elements: [InspirationTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelectItemCategory: Signal<ItemCategory> {
        didSelectItemCategoryTrigger.asSignal()
    }
    
    var didSelectItem: Signal<Item> {
        didSelectItemTrigger.asSignal()
    }
    
    var didSelectLook: Signal<Look> {
        didSelectLookTrigger.asSignal()
    }
    
    var didTapSeeAllRecommendations: Signal<Void> {
        didTapSeeAllRecommendationsTrigger.asSignal()
    }
    
    var didTapCollections: Signal<Void> {
        didTapCollectionsTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension InspirationTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .recommendations(let elements):
            let cell = dequeueReusableCell(withIdentifier: String(describing: InspirationRecommendationsCell.self), for: indexPath) as! InspirationRecommendationsCell
            cell.collectionView.setup(elements: elements)
            cell.collectionView.didSelectItem = { [weak self] item in
                self?.didSelectItemTrigger.accept(item)
            }
            cell.collectionView.didSelectLook = { [weak self] look in
                self?.didSelectLookTrigger.accept(look)
            }
            cell.didTapSeeAll = { [weak self] in
                self?.didTapSeeAllRecommendationsTrigger.accept(Void())
            }
            return cell
        case .itemCategories(let itemCategories):
            let cell = dequeueReusableCell(withIdentifier: String(describing: InspirationItemCategoriesCell.self), for: indexPath) as! InspirationItemCategoriesCell
            cell.setup(itemCategories: itemCategories)
            cell.collectionView.didSelect = { [weak self] itemCategory in
                self?.didSelectItemCategoryTrigger.accept(itemCategory)
            }
            return cell
        case .collections(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: InspirationCollectionsCell.self), for: indexPath) as! InspirationCollectionsCell
            cell.setup(element: element)
            cell.didSelectItemCategory = { [weak self] itemCategory in
                self?.didSelectItemCategoryTrigger.accept(itemCategory)
            }
            cell.didTapCollections = { [weak self] in
                self?.didTapCollectionsTrigger.accept(Void())
            }
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension InspirationTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .recommendations:
            return 186.scale
        case .itemCategories:
            return 60.scale
        case .collections:
            return 346.scale
        }
    }
}

// MARK: Private
private extension InspirationTableView {
    func initialize() {
        register(InspirationRecommendationsCell.self, forCellReuseIdentifier: String(describing: InspirationRecommendationsCell.self))
        register(InspirationItemCategoriesCell.self, forCellReuseIdentifier: String(describing: InspirationItemCategoriesCell.self))
        register(InspirationCollectionsCell.self, forCellReuseIdentifier: String(describing: InspirationCollectionsCell.self))
        
        dataSource = self
        delegate = self
    }
}
