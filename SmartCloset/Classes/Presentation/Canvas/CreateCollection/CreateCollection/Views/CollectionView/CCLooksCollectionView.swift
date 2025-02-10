//
//  CCLooksCollectionView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 10.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CCLooksCollectionView: UICollectionView {
    private lazy var elements = [Look]()
    
    private lazy var didSelectTrigger = PublishRelay<Look>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CCLooksCollectionView {
    func setup(elements: [Look]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<Look> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension CCLooksCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: CCLooksCollectionCell.self), for: indexPath) as! CCLooksCollectionCell
        cell.setup(look: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CCLooksCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension CCLooksCollectionView {
    func initialize() {
        register(CCLooksCollectionCell.self, forCellWithReuseIdentifier: String(describing: CCLooksCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
