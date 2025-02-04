//
//  IICCollectionView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 04.02.2025.
//

import UIKit

final class IICCollectionView: UICollectionView {
    var didSelect: ((ItemCategory) -> Void)?
    
    private lazy var elements = [ItemCategory]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension IICCollectionView {
    func setup(elements: [ItemCategory]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSources
extension IICCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: IICCollectionCell.self), for: indexPath) as! IICCollectionCell
        cell.setup(itemCategory: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension IICCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect?(elements[indexPath.row])
    }
}

// MARK: Private
private extension IICCollectionView {
    func initialize() {
        register(IICCollectionCell.self, forCellWithReuseIdentifier: String(describing: IICCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
