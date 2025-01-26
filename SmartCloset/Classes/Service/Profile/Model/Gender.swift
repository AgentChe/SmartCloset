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
