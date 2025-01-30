//
//  ChangeNameView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 30.01.2025.
//

import UIKit

final class ChangeNameView: ChangeProfileFieldView {
    lazy var nameField = makeNameField()
    lazy var secondNameField = makeSecondNameField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func makeField() -> ChangeProfileFieldView.ChangedField? {
        .name(makeFullName())
    }
    
    override func canSave() -> Bool {
        !makeFullName().isEmpty
    }
}

// MARK: Public
extension ChangeNameView {
    func setup(name: String?) {
        guard let name else { return }
        
        let split = name.split(separator: " ")
        nameField.text = {
            guard let value = split[safe: 0] else { return nil }
            return String(value)
        }()
        secondNameField.text = {
            guard let value = split[safe: 1] else { return nil }
            return String(value)
        }()
        
        namesChanged()
    }
}

// MARK: UITextFieldDelegate
extension ChangeNameView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Private
private extension ChangeNameView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
    
    func makeFullName() -> String {
        let components = [
            (nameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines),
            (secondNameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        ]
        
        return components
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
    
    @objc
    func namesChanged() {
        updateSaveEnable()
    }
}

// MARK: Make constraints
private extension ChangeNameView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            nameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            nameField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            nameField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            secondNameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            secondNameField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            secondNameField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ChangeNameView {
    func makeNameField() -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.regular(size: 16.scale))
            .lineHeight(22.scale)
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono100.withAlphaComponent(0.5))
            .font(Fonts.SofiaSans.regular(size: 16.scale))
            .lineHeight(22.scale)
        
        let view = PaddingTextField()
        view.textPadding = UIEdgeInsets(vertical: 10.scale, horizontal: 16.scale)
        view.backgroundColor = Appearance.main500
        view.defaultTextAttributes = attrs.dictionary
        view.attributedPlaceholder = "Onboarding.Name.NameField.Placeholder".localized.attributed(with: placeholderAttrs)
        view.layer.cornerRadius = 8.scale
        view.layer.masksToBounds = true
        view.delegate = self
        view.addTarget(self, action: #selector(namesChanged), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSecondNameField() -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.regular(size: 16.scale))
            .lineHeight(22.scale)
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono100.withAlphaComponent(0.5))
            .font(Fonts.SofiaSans.regular(size: 16.scale))
            .lineHeight(22.scale)
        
        let view = PaddingTextField()
        view.textPadding = UIEdgeInsets(vertical: 10.scale, horizontal: 16.scale)
        view.backgroundColor = Appearance.main500
        view.defaultTextAttributes = attrs.dictionary
        view.attributedPlaceholder = "Onboarding.Name.SecondNameField.Placeholder".localized.attributed(with: placeholderAttrs)
        view.layer.cornerRadius = 8.scale
        view.layer.masksToBounds = true
        view.delegate = self
        view.addTarget(self, action: #selector(namesChanged), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
