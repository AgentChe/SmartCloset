//
//  InspirationRecommendationsCell.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 05.02.2025.
//

import UIKit

final class InspirationRecommendationsCell: UITableViewCell {
    var didTapSeeAll: (() -> Void)?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var seeAllButton = makeSeeAllButton()
    lazy var collectionView = makeCollectionView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension InspirationRecommendationsCell {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    @objc
    func seeAllTapped() {
        didTapSeeAll?()
    }
}

// MARK: Make constraints
private extension InspirationRecommendationsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            seeAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            seeAllButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 126.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension InspirationRecommendationsCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.regular(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Inspiration.Recommendations".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSeeAllButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100.withAlphaComponent(0.45))
            .font(Fonts.SofiaSans.regular(size: 16.scale))
        
        let view = TapAreaButton()
        view.setAttributedTitle("Inspiration.SeeAll".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(seeAllTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
    
    func makeCollectionView() -> IRCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16.scale
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 122.scale, height: 126.scale)
        
        let view = IRCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsHorizontalScrollIndicator = false
        view.contentInset = UIEdgeInsets(horizontal: 16.scale)
        view.setContentOffset(CGPoint(x: 16.scale, y: 0), animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
