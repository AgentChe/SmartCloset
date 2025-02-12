//
//  CITableCommentsCell.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 12.02.2025.
//

import UIKit

final class CITableCommentsCell: UITableViewCell {
    var didChangeText: ((String?) -> Void)?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var textField = makeTextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UITextFieldDelegate
extension CITableCommentsCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

// MARK: Private
private extension CITableCommentsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func textFieldEditing() {
        didChangeText?(textField.text)
    }
}

// MARK: Make constraints
private extension CITableCommentsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CITableCommentsCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.regular(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.left)
            .lineBreakMode(.byTruncatingTail)
        
        let view = UILabel()
        view.attributedText = "CreateItem.Comments.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextField() -> PaddingTextField {
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono100.withAlphaComponent(0.5))
            .font(Fonts.SofiaSans.regular(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.left)
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.regular(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.left)
            .lineBreakMode(.byTruncatingTail)
        
        let view = PaddingTextField()
        view.attributedPlaceholder = "CreateItem.Comments.Placeholder".localized.attributed(with: placeholderAttrs)
        view.layer.cornerRadius = 3.scale
        view.backgroundColor = Appearance.main500
        view.layer.masksToBounds = true
        view.delegate = self
        view.returnKeyType = .done
        view.defaultTextAttributes = attrs.dictionary
        view.textPadding = UIEdgeInsets(vertical: 11.scale, horizontal: 16.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(textFieldEditing), for: .editingChanged)
        contentView.addSubview(view)
        return view
    }
}
