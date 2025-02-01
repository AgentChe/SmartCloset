//
//  SearchItemsInputView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 01.02.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchItemsInputView: UIView {
    lazy var iconView = makeIconView()
    lazy var textField = makeTextField()
    
    private lazy var searchTrigger = PublishRelay<String>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SearchItemsInputView {
    var search: Signal<String> {
        searchTrigger.asSignal()
    }
}

// MARK: UITextFieldDelegate
extension SearchItemsInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        searchTrigger.accept(textField.text ?? "")
        
        return true
    }
}

// MARK: Private
private extension SearchItemsInputView {
    func initialize() {
        backgroundColor = Appearance.main500
        layer.cornerRadius = 8.scale
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension SearchItemsInputView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50.scale),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SearchItemsInputView {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "SearchItems.Search")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextField() -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.regular(size: 16.scale))
            .lineHeight(22.scale)
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono100.withAlphaComponent(0.5))
            .font(Fonts.SofiaSans.regular(size: 16.scale))
            .lineHeight(22.scale)
        
        let view = PaddingTextField()
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.returnKeyType = .search
        view.defaultTextAttributes = attrs.dictionary
        view.attributedPlaceholder = "SearchItems.Input.Placeholder".localized.attributed(with: placeholderAttrs)
        view.textPadding = UIEdgeInsets(vertical: 11.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
