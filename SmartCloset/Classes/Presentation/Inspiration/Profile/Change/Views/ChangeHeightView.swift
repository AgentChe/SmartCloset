//
//  ChangeHeightView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 30.01.2025.
//

import UIKit

final class ChangeHeightView: ChangeProfileFieldView {
    lazy var valueLabel = makeValueLabel()
    lazy var inchButton = makeUnitButton(unit: .INCH)
    lazy var cmButton = makeUnitButton(unit: .CM)
    lazy var valuesPickerView = makePickerView()
    
    private lazy var unitButtons = [
        inchButton, cmButton
    ]
    
    private lazy var valueAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.regular(size: 16.scale))
        .lineHeight(22.scale)
        .textAlignment(.center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        unitButtonTapped(sender: cmButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func canSave() -> Bool {
        true
    }
    
    override func makeField() -> ChangeProfileFieldView.ChangedField? {
        guard let unit = unitButtons.first(where: { $0.marked })?.object else { return nil }
        
        let height = Height(
            value: valuesPickerView.value,
            unit: unit
        )
        
        return .height(height)
    }
}

// MARK: Public
extension ChangeHeightView {
    func setup(height: Height?) {
        guard let height else { return }
        
        unitButtons.forEach { $0.marked = $0.object == height.unit }
        
        valuesPickerView.setup(unit: height.unit)
        valuesPickerView.setup(value: height.value, unit: height.unit)
    }
}

// MARK: Private
private extension ChangeHeightView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
    
    @objc
    func unitButtonTapped(sender: UIButton) {
        guard let unitButton = sender as? OSelectTextButton<HeightUnit> else { return }
        
        unitButtons.forEach { $0.marked = $0.object == unitButton.object }
        
        valuesPickerView.setup(unit: unitButton.object)
    }
}

// MARK: Make constraints
private extension ChangeHeightView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -156.scale),
            valueLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.scale)
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
    }
}

// MARK: Lazy initialization
private extension ChangeHeightView {
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
}
