//
//  SIFCLCollectionView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 06.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SIFCLCollectionView: UICollectionView {
    var didChangeSelect: ((Bool) -> Void)?
    
    private lazy var elements = [SIFCLCollectionElement]()
    
    private lazy var didScrollToBottomTrigger = PublishRelay<Void>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
        changeSelectNotify()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SIFCLCollectionView {
    func setup(elements: [SIFCLCollectionElement]) {
        self.elements = elements
        
        reloadData()
        
        changeSelectNotify()
    }
    
    func append(elements: [SIFCLCollectionElement]) {
        self.elements.append(contentsOf: elements)
        
        reloadData()
    }
    
    var didScrollToBottom: Signal<Void> {
        didScrollToBottomTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension SIFCLCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: SIFCLCollectionCell.self), for: indexPath) as! SIFCLCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension SIFCLCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        elements.enumerated().forEach { index, element in
            element.selected = index == indexPath.row
        }
        
        reloadData()
        
        changeSelectNotify()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard (elements.count - 1) == indexPath.row else { return }
        didScrollToBottomTrigger.accept(Void())
    }
}

// MARK: Private
private extension SIFCLCollectionView {
    func initialize() {
        register(SIFCLCollectionCell.self, forCellWithReuseIdentifier: String(describing: SIFCLCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
    
    func changeSelectNotify() {
        let selected = elements.contains(where: { $0.selected })
        didChangeSelect?(selected)
    }
}
