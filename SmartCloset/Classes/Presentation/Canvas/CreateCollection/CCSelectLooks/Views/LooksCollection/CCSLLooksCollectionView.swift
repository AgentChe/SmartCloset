//
//  CCSLLooksCollectionView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 10.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CCSLLooksCollectionView: UICollectionView {
    private lazy var elements = [CCSLLooksCollectionElement]()
    
    private lazy var didScrollToBottomTrigger = PublishRelay<Void>()
    private lazy var didChangeSelectedElementsTrigger = PublishRelay<Void>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
        notifyAboutChangeSelected()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CCSLLooksCollectionView {
    func setup(elements: [CCSLLooksCollectionElement]) {
        self.elements = elements
        
        reloadData()
        
        notifyAboutChangeSelected()
    }
    
    func append(elements: [CCSLLooksCollectionElement]) {
        self.elements.append(contentsOf: elements)
        
        reloadData()
    }
    
    var didScrollToBottom: Signal<Void> {
        didScrollToBottomTrigger.asSignal()
    }
    
    var didChangeSelectedElements: Signal<Void> {
        didChangeSelectedElementsTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension CCSLLooksCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: CCSLLooksCollectionCell.self), for: indexPath) as! CCSLLooksCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CCSLLooksCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        elements[indexPath.row].marked.toggle()
        
        reloadData()
        
        notifyAboutChangeSelected()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard (elements.count - 1) == indexPath.row else { return }
        didScrollToBottomTrigger.accept(Void())
    }
}

// MARK: Private
private extension CCSLLooksCollectionView {
    func initialize() {
        register(CCSLLooksCollectionCell.self, forCellWithReuseIdentifier: String(describing: CCSLLooksCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
    
    func notifyAboutChangeSelected() {
        didChangeSelectedElementsTrigger.accept(Void())
    }
}
