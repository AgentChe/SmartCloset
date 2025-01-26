//
//  Season.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 25.01.2025.
//

enum Season: Codable {
    // Коды-идентификаторы в строковом представлении
    enum RawCodes {
        static let winter = "winter"
        static let spring = "spring"
        static let summer = "summer"
        static let autumn = "autumn"
    }
    
    case winter
    case spring
    case summer
    case autumn
    
    init?(rawCodes: String) {
        switch rawCodes {
        case RawCodes.winter:
            self = .winter
        case RawCodes.spring:
            self = .spring
        case RawCodes.summer:
            self = .summer
        case RawCodes.autumn:
            self = .autumn
        default:
            return nil
        }
    }
    
    var rawCode: String {
        switch self {
        case .winter:
            return RawCodes.winter
        case .spring:
            return RawCodes.spring
        case .summer:
            return RawCodes.summer
        case .autumn:
            return RawCodes.autumn
        }
    }
}
