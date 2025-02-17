//
//  LooksCollectionView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 17.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class LooksCollectionView: UICollectionView {
    private lazy var elements = [LooksCollectionElement]()
    
    private lazy var didScrollToBottomTrigger = PublishRelay<Void>()
    private lazy var didTapFavoriteTrigger = PublishRelay<LooksCollectionElement>()
    private lazy var didSelectLookTrigger = PublishRelay<Look>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension LooksCollectionView {
    func setup(elements: [LooksCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    func append(elements: [LooksCollectionElement]) {
        self.elements.append(contentsOf: elements)
        
        reloadData()
    }
    
    func change(favorite: Bool, id: String) {
        guard let index = elements.firstIndex(where: { $0.look.id == id }) else { return }
        
        elements[index].favorite = favorite
        
        let indexPath = IndexPath(row: index, section: 0)
        reloadItems(at: [indexPath])
    }
    
    var didScrollToBottom: Signal<Void> {
        didScrollToBottomTrigger.asSignal()
    }
    
    var didTapFavorite: Signal<LooksCollectionElement> {
        didTapFavoriteTrigger.asSignal()
    }
    
    var didSelectLook: Signal<Look> {
        didSelectLookTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension LooksCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = elements[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: LooksCollectionCell.self), for: indexPath) as! LooksCollectionCell
        cell.setup(element: element)
        cell.didTapFavorite = { [weak self] in
            self?.didTapFavoriteTrigger.accept(element)
        }
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension LooksCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectLookTrigger.accept(elements[indexPath.row].look)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard (elements.count - 1) == indexPath.row else { return }
        didScrollToBottomTrigger.accept(Void())
    }
}

// MARK: Private
private extension LooksCollectionView {
    func initialize() {
        register(LooksCollectionCell.self, forCellWithReuseIdentifier: String(describing: LooksCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
