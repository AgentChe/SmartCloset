//
//  WICollectionHeader.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 18.02.2025.
//

import UIKit
import RxSwift

final class WICollectionHeader: UICollectionReusableView {
    var didSelectCategory: ((ItemCategory) -> Void)?
    var didTapSelectType: (() -> Void)?
    var didTapFavoriteMode: (() -> Void)?
    
    lazy var categoriesView = makeCategoriesView()
    lazy var selectTypeButton = makeSelectTypeButton()
    lazy var favoriteButton = makeFavoriteButton()
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension WICollectionHeader {
    func initialize() {
        backgroundColor = UIColor.clear
        
        categoriesView.didSelect
            .emit(to: Binder(self) { base, itemCategory in
                base.didSelectCategory?(itemCategory)
            })
            .disposed(by: disposeBag)
        
        selectTypeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.didTapSelectType?()
            })
            .disposed(by: disposeBag)
        
        favoriteButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.didTapFavoriteMode?()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make constraints
private extension WICollectionHeader {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            categoriesView.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoriesView.trailingAnchor.constraint(equalTo: trailingAnchor),
            categoriesView.topAnchor.constraint(equalTo: topAnchor),
            categoriesView.heightAnchor.constraint(equalToConstant: 90.scale)
        ])
        
        NSLayoutConstraint.activate([
            selectTypeButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectTypeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60.scale),
            selectTypeButton.heightAnchor.constraint(equalToConstant: 44.scale),
            selectTypeButton.topAnchor.constraint(equalTo: categoriesView.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            favoriteButton.widthAnchor.constraint(equalToConstant: 44.scale),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44.scale),
            favoriteButton.centerYAnchor.constraint(equalTo: selectTypeButton.centerYAnchor),
            favoriteButton.leadingAnchor.constraint(equalTo: selectTypeButton.trailingAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WICollectionHeader {
    func makeCategoriesView() -> AITWCategoriesView {
        let view = AITWCategoriesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSelectTypeButton() -> ICSelectTypeButton {
        let view = ICSelectTypeButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFavoriteButton() -> WardrobeItemsFavoriteButton {
        let view = WardrobeItemsFavoriteButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
