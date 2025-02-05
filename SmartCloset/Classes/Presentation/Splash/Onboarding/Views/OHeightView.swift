//
//  OHeightView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 27.01.2025.
//

import UIKit

final class OHeightView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var valueLabel = makeValueLabel()
    lazy var inchButton = makeUnitButton(unit: .INCH)
    lazy var cmButton = makeUnitButton(unit: .CM)
    lazy var valuesPickerView = makePickerView()
    lazy var nextButton = makeNextButton()
    
    private lazy var unitButtons = [
        inchButton, cmButton
    ]
    
    private lazy var valueAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.regular(size: 16.scale))
        .lineHeight(22.scale)
        .textAlignment(.center)
    
    private let complete: (Height?) -> Void
    
    init(complete: @escaping (Height?) -> Void) {
        self.complete = complete
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        unitButtonTapped(sender: cmButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OHeightView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
    
    @objc
    func nextTapped() {
        guard let unit = unitButtons.first(where: { $0.marked })?.object else { return }
        
        let height = Height(
            value: valuesPickerView.value,
            unit: unit
        )
        
        complete(height)
    }
    
    @objc
    func skipTapped() {
        complete(nil)
    }
    
    @objc
    func unitButtonTapped(sender: UIButton) {
        guard let unitButton = sender as? OSelectTextButton<HeightUnit> else { return }
        
        unitButtons.forEach { $0.marked = $0.object == unitButton.object }
        
        valuesPickerView.setup(unit: unitButton.object)
    }
}

// MARK: Make constraints
private extension OHeightView {
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
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -156.scale),
            valueLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            inchButton.widthAnchor.constraint(equalToConstant: 56.scale),
            inchButton.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 16.scale),
            inchButton.topAnchor.constraint(equalTo: valueLabel.topAnchor),
            inchButton.bottomAnchor.constraint(equalTo: valueLabel.bottomAnchor),
            inchButton.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cmButton.widthAnchor.constraint(equalToConstant: 56.scale),
            cmButton.leadingAnchor.constraint(equalTo: inchButton.trailingAnchor, constant: 12.scale),
            cmButton.topAnchor.constraint(equalTo: valueLabel.topAnchor),
            cmButton.bottomAnchor.constraint(equalTo: valueLabel.bottomAnchor),
            cmButton.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            valuesPickerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            valuesPickerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            valuesPickerView.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            nextButton.heightAnchor.constraint(equalToConstant: 52.scale),
            nextButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OHeightView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.bold(size: 22.scale))
            .lineHeight(26.scale)
            .letterSpacing(-0.32.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Height.Title".localized.attributed(with: attrs)
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
        view.attributedText = "Onboarding.Height.SubTitle".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeValueLabel() -> PaddingLabel {
        let view = PaddingLabel()
        view.insets = UIEdgeInsets(vertical: 10.scale, horizontal: 16.scale)
        view.attributedText = " ".attributed(with: valueAttrs) // Чтобы изначально была норм высота
        view.backgroundColor = Appearance.main500
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeUnitButton(unit: HeightUnit) -> OSelectTextButton<HeightUnit> {
        let view = OSelectTextButton(object: unit, title: HeightUnit.DefaultLocalized(unit: unit).name)
        view.addTarget(self, action: #selector(unitButtonTapped(sender:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePickerView() -> OHeightPickerView {
        let view = OHeightPickerView { [weak self] localizedValue in
            guard let self else { return }
            
            valueLabel.attributedText = localizedValue.attributed(with: valueAttrs)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNextButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SofiaSans.bold(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Next".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main100
        view.layer.cornerRadius = 3.scale
        view.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
