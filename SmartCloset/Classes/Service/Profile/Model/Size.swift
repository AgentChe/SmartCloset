//
//  Size.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 24.01.2025.
//

enum Size: Codable {
    // Коды-идентификаторы в строковом представлении
    enum RawCodes {
        static let XXS = "XXS"
        static let XS = "XS"
        static let S = "S"
        static let M = "M"
        static let L = "L"
        static let XL = "XL"
        static let XXL = "XL"
    }
    
    case XXS
    case XS
    case S
    case M
    case L
    case XL
    case XXL
    
    init?(rawCode: String) {
        switch rawCode {
        case RawCodes.XXS:
            self = .XXS
        case RawCodes.XS:
            self = .XS
        case RawCodes.S:
            self = .S
        case RawCodes.M:
            self = .M
        case RawCodes.L:
            self = .L
        case RawCodes.XL:
            self = .XL
        case RawCodes.XXL:
            self = .XXL
        default:
            return nil
        }
    }
    
    var rawCode: String {
        switch self {
        case .XXS:
            return RawCodes.XXS
        case .XS:
            return RawCodes.XS
        case .S:
            return RawCodes.S
        case .M:
            return RawCodes.M
        case .L:
            return RawCodes.L
        case .XL:
            return RawCodes.XL
        case .XXL:
            return RawCodes.XXL
        }
    }
}

// MARK: Public (Additional)
extension Size {
    struct DefaultLocalized {
        private let size: Size
        
        init(size: Size) {
            self.size = size
        }
        
        var name: String {
            switch size {
            case .XXS:
                return "Size.XXS".localized
            case .XS:
                return "Size.XS".localized
            case .S:
                return "Size.S".localized
            case .M:
                return "Size.M".localized
            case .L:
                return "Size.L".localized
            case .XL:
                return "Size.XL".localized
            case .XXL:
                return "Size.XXL".localized
            }
        }
    }
}
