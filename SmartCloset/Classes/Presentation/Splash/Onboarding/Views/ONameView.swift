//
//  ONameView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 27.01.2025.
//

import UIKit

final class ONameView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var nameField = makeNameField()
    lazy var secondNameField = makeSecondNameField()
    lazy var nextButton = makeNextButton()
    
    private let complete: (String) -> Void
    
    private lazy var nextButtonEnableAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.bold(size: 18.scale))
    private lazy var nextButtonDisableAttrs = TextAttributes()
        .textColor(Appearance.mono100.withAlphaComponent(0.4))
        .font(Fonts.SofiaSans.bold(size: 18.scale))
    
    init(complete: @escaping (String) -> Void) {
        self.complete = complete
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        namesChanged()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ONameView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Private
private extension ONameView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
    
    @objc
    func namesChanged() {
        let enable = !makeFullName().isEmpty
        
        nextButton.isEnabled = enable
        nextButton.backgroundColor = enable ? Appearance.main100 : Appearance.main400
        
        let attrs = enable ? nextButtonEnableAttrs : nextButtonDisableAttrs
        nextButton.setAttributedTitle("Next".localized.attributed(with: attrs), for: .normal)
    }
    
    @objc
    func nextTapped() {
        let fullName = makeFullName()
        
        guard !fullName.isEmpty else { return }
        
        [nameField, secondNameField].forEach { $0.resignFirstResponder() }
        
        complete(fullName)
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
}

// MARK: Make constraints
private extension ONameView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            nameField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            nameField.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            secondNameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            secondNameField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            secondNameField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            nextButton.heightAnchor.constraint(equalToConstant: 52.scale),
            nextButton.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ONameView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.bold(size: 22.scale))
            .lineHeight(26.scale)
            .letterSpacing(-0.32.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Name.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.regular(size: 16.scale))
            .lineHeight(20.scale)
            .letterSpacing(-0.32.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Name.SubTitle".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
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
    
    func makeNextButton() -> UIButton {
        let view = UIButton()
        view.layer.cornerRadius = 3.scale
        view.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
