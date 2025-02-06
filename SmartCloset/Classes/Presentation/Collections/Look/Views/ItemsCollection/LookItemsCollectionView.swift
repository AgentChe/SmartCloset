//
//  LookItemsCollectionView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 05.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class LookItemsCollectionView: UICollectionView {
    private lazy var elements = [Item]()
    
    private lazy var didSelectItemTrigger = PublishRelay<Item>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension LookItemsCollectionView {
    func setup(elements: [Item]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelectItem: Signal<Item> {
        didSelectItemTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension LookItemsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: LookItemsCollectionCell.self), for: indexPath) as! LookItemsCollectionCell
        cell.setup(item: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension LookItemsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItemTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension LookItemsCollectionView {
    func initialize() {
        register(LookItemsCollectionCell.self, forCellWithReuseIdentifier: String(describing: LookItemsCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
