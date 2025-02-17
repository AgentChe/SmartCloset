//
//  WLTableCell.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 17.02.2025.
//

import UIKit
import RxSwift

final class WLTableCell: UITableViewCell {
    var didTapSeeMore: (() -> Void)?
    var didSelectLook: ((Look) -> Void)?
    
    lazy var label = makeLabel()
    lazy var seeMoreButton = makeSeeMore()
    lazy var collectionView = makeCollectionView()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.regular(size: 16.scale))
        .lineHeight(22.scale)
        .textAlignment(.left)
    
    private var disposable: Disposable?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WLTableCell {
    func setup(element: WLTableElement) {
        disposable?.dispose()
        disposable = collectionView.didSelect
            .emit(to: Binder(self) { base, element in
                base.didSelectLook?(element)
            })
        
        label.attributedText = element.block.name.attributed(with: attrs)
        collectionView.setup(elements: element.looks)
    }
}

// MARK: Private
private extension WLTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func seeMoreTapped() {
        didTapSeeMore?()
    }
}

// MARK: Make constraints
private extension WLTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            seeMoreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            seeMoreButton.centerYAnchor.constraint(equalTo: label.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 58.scale),
            collectionView.heightAnchor.constraint(equalToConstant: 174.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WLTableCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSeeMore() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100.withAlphaComponent(0.4))
            .font(Fonts.SofiaSans.regular(size: 16.scale))
        
        let view = TapAreaButton()
        view.setAttributedTitle("Wardrobe.SeeMore".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(seeMoreTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeCollectionView() -> CCLooksCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20.scale
        layout.minimumInteritemSpacing = 0.scale
        layout.itemSize = CGSize(width: 171.scale, height: 175.scale)
        
        let view = CCLooksCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(horizontal: 16.scale)
        view.setContentOffset(CGPoint(x: 16.scale, y: 0), animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

// MARK: Additional
private extension WLTableElement.Block {
    var name: String {
        switch self {
        case .favorites:
            return "Wardrobe.Block.Favorites".localized
        case .allLooks:
            return "Wardrobe.Block.AllLooks".localized
        }
    }
}
