//
//  HeightUnit.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 24.01.2025.
//

enum HeightUnit: Codable {
    // Коды-идентификаторы в строковом представлении
    enum RawCodes {
        static let INCHCode = "INCH"
        static let CMCode = "CM"
    }
    
    case INCH
    case CM
    
    init?(rawCode: String) {
        switch rawCode {
        case RawCodes.INCHCode:
            self = .INCH
        case RawCodes.CMCode:
            self = .CM
        default:
            return nil
        }
    }
    
    var rawCode: String {
        switch self {
        case .INCH:
            return RawCodes.INCHCode
        case .CM:
            return RawCodes.CMCode
        }
    }
}
