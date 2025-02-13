//
//  AddItemToWardrobeCollectionView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 13.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class AddItemToWardrobeCollectionView: UICollectionView {
    private lazy var elements = [AddItemToWardrobeCollectionElement]()
    
    private lazy var didScrollToBottomTrigger = PublishRelay<Void>()
    private lazy var didChangeSelectedTrigger = PublishRelay<Void>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
        didChangeSelectedTrigger.accept(Void())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension AddItemToWardrobeCollectionView {
    func setup(elements: [AddItemToWardrobeCollectionElement]) {
        self.elements = elements
        
        reloadData()
        
        didChangeSelectedTrigger.accept(Void())
    }
    
    func append(elements: [AddItemToWardrobeCollectionElement]) {
        self.elements.append(contentsOf: elements)
        
        reloadData()
    }
    
    var didScrollToBottom: Signal<Void> {
        didScrollToBottomTrigger.asSignal()
    }
    
    var didChangeSelected: Signal<Void> {
        didChangeSelectedTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension AddItemToWardrobeCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = elements[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: AddItemToWardrobeCollectionCell.self), for: indexPath) as! AddItemToWardrobeCollectionCell
        cell.setup(element: element)
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension AddItemToWardrobeCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard (elements.count - 1) == indexPath.row else { return }
        didScrollToBottomTrigger.accept(Void())
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        elements.enumerated().forEach { index, element in
            element.marked = index == indexPath.row
        }
        
        reloadData()
        
        didChangeSelectedTrigger.accept(Void())
    }
}

// MARK: Private
private extension AddItemToWardrobeCollectionView {
    func initialize() {
        register(AddItemToWardrobeCollectionCell.self, forCellWithReuseIdentifier: String(describing: AddItemToWardrobeCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
