//
//  IRCollectionView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 05.02.2025.
//

import UIKit

final class IRCollectionView: UICollectionView {
    var didSelectItem: ((Item) -> Void)?
    var didSelectLook: ((Look) -> Void)?
    
    private lazy var elements = [InspirationTableRecommendationsElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initilaize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension IRCollectionView {
    func setup(elements: [InspirationTableRecommendationsElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension IRCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .item(let item):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: IRCollectionItemCell.self), for: indexPath) as! IRCollectionItemCell
            cell.setup(item: item)
            return cell
        case .look(let look):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: IRCollectionLookCell.self), for: indexPath) as! IRCollectionLookCell
            cell.setup(look: look)
            return cell
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension IRCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .item(let item):
            didSelectItem?(item)
        case .look(let look):
            didSelectLook?(look)
        }
    }
}

// MARK: Private
private extension IRCollectionView {
    func initilaize() {
        register(IRCollectionItemCell.self, forCellWithReuseIdentifier: String(describing: IRCollectionItemCell.self))
        register(IRCollectionLookCell.self, forCellWithReuseIdentifier: String(describing: IRCollectionLookCell.self))
        
        dataSource = self
        delegate = self
    }
}
