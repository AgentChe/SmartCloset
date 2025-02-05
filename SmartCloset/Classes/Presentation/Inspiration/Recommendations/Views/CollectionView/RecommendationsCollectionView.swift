//
//  RecommendationsCollectionView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 05.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class RecommendationsCollectionView: UICollectionView {
    private lazy var elements = [RecommendationsCollectionElement]()
    
    private lazy var didScrollToBottomTrigger = PublishRelay<Void>()
    private lazy var didSelectItemTrigger = PublishRelay<Item>()
    private lazy var didSelectLookTrigger = PublishRelay<Look>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initilaize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension RecommendationsCollectionView {
    func setup(elements: [RecommendationsCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    func append(elements: [RecommendationsCollectionElement]) {
        self.elements.append(contentsOf: elements)
        
        reloadData()
    }
    
    var didScrollToBottom: Signal<Void> {
        didScrollToBottomTrigger.asSignal()
    }
    
    var didSelectItem: Signal<Item> {
        didSelectItemTrigger.asSignal()
    }
    
    var didSelectLook: Signal<Look> {
        didSelectLookTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension RecommendationsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .item(let item):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: RecommendationsCollectionItemCell.self), for: indexPath) as! RecommendationsCollectionItemCell
            cell.setup(item: item)
            return cell
        case .look(let look):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: RecommendationsCollectionLookCell.self), for: indexPath) as! RecommendationsCollectionLookCell
            cell.setup(look: look)
            return cell
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension RecommendationsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard (elements.count - 1) == indexPath.row else { return }
        didScrollToBottomTrigger.accept(Void())
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .item(let item):
            didSelectItemTrigger.accept(item)
        case .look(let look):
            didSelectLookTrigger.accept(look)
        }
    }
}

// MARK: Private
private extension RecommendationsCollectionView {
    func initilaize() {
        register(RecommendationsCollectionItemCell.self, forCellWithReuseIdentifier: String(describing: RecommendationsCollectionItemCell.self))
        register(RecommendationsCollectionLookCell.self, forCellWithReuseIdentifier: String(describing: RecommendationsCollectionLookCell.self))
        
        dataSource = self
        delegate = self
    }
}
