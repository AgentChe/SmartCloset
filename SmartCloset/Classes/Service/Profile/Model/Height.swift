//
//  Height.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 24.01.2025.
//

struct Height: Codable {
    let value: Double
    let unit: HeightUnit
}

// MARK: Public (Additional)
extension Height {
    struct DefaultLocalized {
        private let height: Height
        
        init(height: Height) {
            self.height = height
        }
        
        var value: String? {
            let value: String? = {
                switch height.unit {
                case .INCH:
                    if height.value.truncatingRemainder(dividingBy: 1) == 0 {
                        return String(Int(height.value))
                    } else {
                        return String(height.value)
                    }
                case .CM:
                    return String(Int(height.value))
                }
            }()
            guard let value else { return nil }
            
            let localizedUnit = HeightUnit.DefaultLocalized(unit: height.unit).name.lowercased()
            
            return "\(value) \(localizedUnit)"
        }
    }
}
