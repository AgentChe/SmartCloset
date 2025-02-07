//
//  CLItemsCollectionView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 07.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CLItemsCollectionView: UICollectionView {
    private lazy var elements = [CLItemsCollectionElement]()
    
    private lazy var didSelectItemCategoryTrigger = PublishRelay<ItemCategory>()
    private lazy var didSelectItemTrigger = PublishRelay<Item>()
    private lazy var didScrollToLastTrigger = PublishRelay<Void>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CLItemsCollectionView {
    func setup(elements: [CLItemsCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    func append(elements: [CLItemsCollectionElement]) {
        self.elements.append(contentsOf: elements)
        
        reloadData()
    }
    
    var didSelectItemCategory: Signal<ItemCategory> {
        didSelectItemCategoryTrigger.asSignal()
    }
    
    var didSelectItem: Signal<Item> {
        didSelectItemTrigger.asSignal()
    }
    
    var didScrollToLast: Signal<Void> {
        didScrollToLastTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension CLItemsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .selectItem(let itemCategory):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: CLItemsCollectionSelectItemCell.self), for: indexPath) as! CLItemsCollectionSelectItemCell
            cell.setup(itemCategory: itemCategory)
            return cell
        case .item(let element):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: CLItemsCollectionItemCell.self), for: indexPath) as! CLItemsCollectionItemCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CLItemsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard case let .selectItem(itemCategory) = elements[indexPath.row] else { return }
        didSelectItemCategoryTrigger.accept(itemCategory)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard (elements.count - 1) == indexPath.row else { return }
        didScrollToLastTrigger.accept(Void())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch elements[indexPath.row] {
        case .selectItem:
            return CGSize(width: bounds.width - 32.scale, height: bounds.height)
        case .item:
            return CGSize(width: bounds.height, height: bounds.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let element = elements.first else {
            return UIEdgeInsets(horizontal: 16.scale)
        }
        
        switch element {
        case .selectItem:
            return UIEdgeInsets(horizontal: 16.scale)
        case .item:
            let inset = bounds.width * 0.5 - bounds.height * 0.5
            return UIEdgeInsets(horizontal: inset)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let centerPoint = CGPoint(
            x: scrollView.contentOffset.x + bounds.width / 2,
            y: bounds.height / 2
        )
        
        guard let indexPath = indexPathForItem(at: centerPoint) else { return }
        
        elements.forEach { element in
            guard case let .item(item) = element else { return }
            item.selected = false
        }
        
        guard let element = elements[safe: indexPath.row], case let .item(itemElement) = element else { return }
        
        itemElement.selected = true
        
        reloadData()
        
        didSelectItemTrigger.accept(itemElement.item)
    }
}

// MARK: Private
private extension CLItemsCollectionView {
    func initialize() {
        register(CLItemsCollectionSelectItemCell.self, forCellWithReuseIdentifier: String(describing: CLItemsCollectionSelectItemCell.self))
        register(CLItemsCollectionItemCell.self, forCellWithReuseIdentifier: String(describing: CLItemsCollectionItemCell.self))
        
        dataSource = self
        delegate = self
    }
}
