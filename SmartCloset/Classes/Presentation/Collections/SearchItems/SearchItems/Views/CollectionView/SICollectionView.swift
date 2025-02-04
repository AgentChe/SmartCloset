//
//  SICollectionView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 03.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SICollectionView: UICollectionView {
    private lazy var elements = [SICollectionElement]()
    
    private lazy var didScrollToBottomTrigger = PublishRelay<Void>()
    private lazy var didTapFavoriteTrigger = PublishRelay<SICollectionElement>()
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
extension SICollectionView {
    func setup(elements: [SICollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    func append(elements: [SICollectionElement]) {
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
    
    var didTapFavorite: Signal<SICollectionElement> {
        didTapFavoriteTrigger.asSignal()
    }
    
    var didSelectItem: Signal<Item> {
        didSelectItemTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension SICollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = elements[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: SICollectionCell.self), for: indexPath) as! SICollectionCell
        cell.setup(element: element)
        cell.didTapFavorite = { [weak self] in
            self?.didTapFavoriteTrigger.accept(element)
        }
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension SICollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard (elements.count - 1) == indexPath.row else { return }
        didScrollToBottomTrigger.accept(Void())
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItemTrigger.accept(elements[indexPath.row].item)
    }
}

// MARK: Private
private extension SICollectionView {
    func initialize() {
        register(SICollectionCell.self, forCellWithReuseIdentifier: String(describing: SICollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
