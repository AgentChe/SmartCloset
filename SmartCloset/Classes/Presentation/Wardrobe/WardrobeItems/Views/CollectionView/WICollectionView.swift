//
//  WICollectionView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 18.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class WICollectionView: UICollectionView {
    private lazy var elements = [WICollectionElement]()
    
    private lazy var didScrollToBottomTrigger = PublishRelay<Void>()
    private lazy var didTapFavoriteTrigger = PublishRelay<WICollectionElement>()
    private lazy var didSelectItemTrigger = PublishRelay<Item>()
    private lazy var didSelectCategoryTrigger = PublishRelay<ItemCategory>()
    private lazy var didTapSelectTypeTrigger = PublishRelay<Void>()
    private lazy var didTapFavoriteModeTrigger = PublishRelay<Void>()
    
    private weak var headerView: WICollectionHeader?
    
    private var itemCategory: ItemCategory?
    private var itemType: ItemType?
    private var favoriteMode: Bool?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WICollectionView {
    func setup(itemCategory: ItemCategory) {
        self.itemCategory = itemCategory
        headerView?.categoriesView.setup(category: itemCategory)
    }
    
    func setup(itemType: ItemType?) {
        self.itemType = itemType
        headerView?.selectTypeButton.setup(itemType: itemType)
    }
    
    func setup(favoriteMode: Bool) {
        self.favoriteMode = favoriteMode
        headerView?.favoriteButton.setup(favorite: favoriteMode)
    }
    
    func setup(elements: [WICollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    func append(elements: [WICollectionElement]) {
        self.elements.append(contentsOf: elements)
        
        reloadData()
    }
    
    func change(favorite: Bool, id: String) {
        guard let index = elements.firstIndex(where: { $0.item.id == id }) else { return }
        
        elements[index].favorite = favorite
        
        let indexPath = IndexPath(row: index, section: 0)
        reloadItems(at: [indexPath])
    }
    
    var didScrollToBottom: Signal<Void> {
        didScrollToBottomTrigger.asSignal()
    }
    
    var didTapFavorite: Signal<WICollectionElement> {
        didTapFavoriteTrigger.asSignal()
    }
    
    var didSelectItem: Signal<Item> {
        didSelectItemTrigger.asSignal()
    }
    
    var didSelectCategory: Signal<ItemCategory> {
        didSelectCategoryTrigger.asSignal()
    }
    
    var didTapSelectType: Signal<Void> {
        didTapSelectTypeTrigger.asSignal()
    }
    
    var didTapFavoriteMode: Signal<Void> {
        didTapFavoriteModeTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension WICollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = elements[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WICollectionCell.self), for: indexPath) as! WICollectionCell
        cell.setup(element: element)
        cell.didTapFavorite = { [weak self] in
            self?.didTapFavoriteTrigger.accept(element)
        }
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension WICollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItemTrigger.accept(elements[indexPath.row].item)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard (elements.count - 1) == indexPath.row else { return }
        didScrollToBottomTrigger.accept(Void())
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: WICollectionHeader.self), for: indexPath) as! WICollectionHeader
        self.headerView = header
        header.didSelectCategory = { [weak self] itemCategory in
            self?.didSelectCategoryTrigger.accept(itemCategory)
        }
        header.didTapSelectType = { [weak self] in
            self?.didTapSelectTypeTrigger.accept(Void())
        }
        header.didTapFavoriteMode = { [weak self] in
            self?.didTapFavoriteModeTrigger.accept(Void())
        }
        if let itemCategory {
            header.categoriesView.setup(category: itemCategory)
        }
        header.selectTypeButton.setup(itemType: itemType)
        if let favoriteMode {
            header.favoriteButton.setup(favorite: favoriteMode)
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: bounds.width, height: 174.scale)
    }
}

// MARK: Private
private extension WICollectionView {
    func initialize() {
        register(WICollectionCell.self, forCellWithReuseIdentifier: String(describing: WICollectionCell.self))
        register(WICollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: WICollectionHeader.self))
        
        dataSource = self
        delegate = self
    }
}
