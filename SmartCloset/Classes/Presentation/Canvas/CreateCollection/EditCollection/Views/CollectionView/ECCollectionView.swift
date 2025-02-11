//
//  ECCollectionView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 11.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ECCollectionView: UICollectionView {
    private lazy var elements = [ECCollectionElement]()
    
    private lazy var didTapAddLookTrigger = PublishRelay<Void>()
    private lazy var didTapDeleteLookTrigger = PublishRelay<Look>()
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
extension ECCollectionView {
    func setup(elements: [ECCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didTapAddLook: Signal<Void> {
        didTapAddLookTrigger.asSignal()
    }
    
    var didTapDeleteLook: Signal<Look> {
        didTapDeleteLookTrigger.asSignal()
    }
    
    var didSelectLook: Signal<Look> {
        didSelectLookTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension ECCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .addLook:
            return dequeueReusableCell(withReuseIdentifier: String(describing: ECCollectionAddLookCell.self), for: indexPath)
        case .look(let look):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: ECCollectionLookCell.self), for: indexPath) as! ECCollectionLookCell
            cell.setup(look: look)
            cell.didDelete = { [weak self] in
                self?.didTapDeleteLookTrigger.accept(look)
            }
            return cell
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ECCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch elements[indexPath.row] {
        case .addLook:
            return CGSize(width: bounds.width, height: 98.scale)
        case .look:
            return CGSize(width: 171.scale, height: 175.scale)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .addLook:
            didTapAddLookTrigger.accept(Void())
        case .look(let look):
            didSelectLookTrigger.accept(look)
        }
    }
}

// MARK: Private
private extension ECCollectionView {
    func initialize() {
        register(ECCollectionAddLookCell.self, forCellWithReuseIdentifier: String(describing: ECCollectionAddLookCell.self))
        register(ECCollectionLookCell.self, forCellWithReuseIdentifier: String(describing: ECCollectionLookCell.self))
        
        dataSource = self
        delegate = self
    }
}
