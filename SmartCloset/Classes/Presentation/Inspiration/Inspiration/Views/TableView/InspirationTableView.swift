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
}

// MARK: UITableViewDataSource
extension InspirationTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
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
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension InspirationTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
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
        register(InspirationItemCategoriesCell.self, forCellReuseIdentifier: String(describing: InspirationItemCategoriesCell.self))
        register(InspirationCollectionsCell.self, forCellReuseIdentifier: String(describing: InspirationCollectionsCell.self))
        
        dataSource = self
        delegate = self
    }
}
