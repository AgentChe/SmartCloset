//
//  WCCollectionView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 16.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class WCCollectionView: UICollectionView {
    private lazy var elements = [Collection]()
    
    private lazy var didScrollToBottomTrigger = PublishRelay<Void>()
    private lazy var didSelectCollectionTrigger = PublishRelay<Collection>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WCCollectionView {
    func setup(elements: [Collection]) {
        self.elements = elements
        
        reloadData()
    }
    
    func append(elements: [Collection]) {
        self.elements.append(contentsOf: elements)
        
        reloadData()
    }
    
    var didScrollToBottom: Signal<Void> {
        didScrollToBottomTrigger.asSignal()
    }
    
    var didSelectCollection: Signal<Collection> {
        didSelectCollectionTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension WCCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WCCollectionCell.self), for: indexPath) as! WCCollectionCell
        cell.setup(collection: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension WCCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: bounds.width, height: 408.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard (elements.count - 1) == indexPath.row else { return }
        didScrollToBottomTrigger.accept(Void())
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCollectionTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension WCCollectionView {
    func initialize() {
        register(WCCollectionCell.self, forCellWithReuseIdentifier: String(describing: WCCollectionCell.self))
        
        delegate = self
        dataSource = self
    }
}
