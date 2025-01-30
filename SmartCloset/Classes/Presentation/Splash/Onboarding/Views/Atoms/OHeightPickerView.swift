//
//  OHeightPickerView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 27.01.2025.
//

import UIKit

final class OHeightPickerView: UIView {
    private lazy var pickerView = makePickerView()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SofiaSans.regular(size: 23.scale))
        .lineHeight(28.scale)
        .letterSpacing(2.35.scale)
        .textAlignment(.center)
    
    private var unit: HeightUnit = .CM
    
    private let change: (String) -> Void
    
    init(change: @escaping (String) -> Void) {
        self.change = change
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension OHeightPickerView {
    func setup(unit: HeightUnit) {
        self.unit = unit
        
        pickerView.reloadAllComponents()
        notifyChange()
    }
    
    func setup(value: Double, unit: HeightUnit) {
        switch unit {
        case .CM:
            let row = Int(value) - Constants.minCM
            if row >= 0, pickerView(pickerView, numberOfRowsInComponent: 0) >= (row + 1) {
                pickerView.selectRow(row, inComponent: 0, animated: false)
                
                notifyChange()
            }
        case .INCH:
            let split = String(value).split(separator: ".")
            
            guard
                let integerString = split[safe: 0], let integer = Int(integerString),
                let fractionalString = split[safe: 1], let fractional = Int(fractionalString)
            else { return }
            
            let integerRow = integer - Constants.minINCH
            if integerRow >= 0, pickerView(pickerView, numberOfRowsInComponent: 0) >= (integerRow + 1) {
                pickerView.selectRow(integerRow, inComponent: 0, animated: false)
            }
            
            let fractionalRow = fractional
            if fractionalRow >= 0, pickerView(pickerView, numberOfRowsInComponent: 1) >= fractionalRow {
                pickerView.selectRow(fractionalRow, inComponent: 1, animated: false)
            }
            
            notifyChange()
        }
    }
    
    var value: Double {
        switch unit {
        case .INCH:
            guard numberOfComponents(in: pickerView) == 2 else { return Double(Constants.minINCH) }
            
            let v1 = Double(pickerView.selectedRow(inComponent: 0) + Constants.minINCH)
            let v2 = Double(pickerView.selectedRow(inComponent: 1)) / 10
            return v1 + v2
        case .CM:
            guard numberOfComponents(in: pickerView) == 1 else { return Double(Constants.minCM) }
        
            let value = pickerView.selectedRow(inComponent: 0) + Constants.minCM
            return Double(value)
        }
    }
}

// MARK: UIPickerViewDataSource
extension OHeightPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch unit {
        case .INCH:
            return 2
        case .CM:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            switch unit {
            case .INCH:
                return (Constants.minINCH...Constants.maxINCH).count
            case .CM:
                return (Constants.minCM...Constants.maxCM).count
            }
        case 1:
            return 10
        default:
            return 0
        }
    }
}

// MARK: UIPickerViewDelegate
extension OHeightPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        switch component {
        case 0:
            switch unit {
            case .INCH:
                return String(row + Constants.minINCH).attributed(with: attrs)
            case .CM:
                return String(row + Constants.minCM).attributed(with: attrs)
            }
        case 1:
            return String(row).attributed(with: attrs)
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        notifyChange()
    }
}

// MARK: Private
private extension OHeightPickerView {
    enum Constants {
        static let minINCH = 20
        static let maxINCH = 110
        static let minCM = 50
        static let maxCM = 275
    }
    
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func notifyChange() {
        switch unit {
        case .INCH:
            guard numberOfComponents(in: pickerView) == 2 else { return }
            
            let v1 = Double(pickerView.selectedRow(inComponent: 0) + Constants.minINCH)
            let v2 = Double(pickerView.selectedRow(inComponent: 1)) / 10
            let localizedValue = String(v1 + v2)
            change(localizedValue)
        case .CM:
            guard numberOfComponents(in: pickerView) == 1 else { return }
        
            let value = pickerView.selectedRow(inComponent: 0)
            let localizedValue = String(value + Constants.minCM)
            change(localizedValue)
        }
    }
}

// MARK: Make constraints
private extension OHeightPickerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pickerView.topAnchor.constraint(equalTo: topAnchor),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OHeightPickerView {
    func makePickerView() -> UIPickerView {
        let view = UIPickerView()
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
