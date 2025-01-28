//
//  Gender.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 24.01.2025.
//

enum Gender: Codable {
    // Коды-идентификаторы в строковом представлении
    enum RawCodes {
        static let female = "female"
        static let male = "male"
    }
    
    case female
    case male
    
    init?(rawCode: String) {
        switch rawCode {
        case RawCodes.female:
            self = .female
        case RawCodes.male:
            self = .male
        default:
            return nil
        }
    }
    
    var rawCode: String {
        switch self {
        case .female:
            return RawCodes.female
        case .male:
            return RawCodes.male
        }
    }
}

// MARK: Public (Additional)
extension Gender {
    struct DefaultLocalized {
        private let gender: Gender
        
        init(gender: Gender) {
            self.gender = gender
        }
        
        var name: String {
            switch gender {
            case .female:
                return "Gender.Female".localized
            case .male:
                return "Gender.Male".localized
            }
        }
    }
}
