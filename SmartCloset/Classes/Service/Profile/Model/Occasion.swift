//
//  Occasion.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 25.01.2025.
//

enum Occasion: Codable, CaseIterable {
    // Коды-идентификаторы в строковом представлении
    enum RawCodes {
        static let work = "work"
        static let dailyActivities = "dailyActivities"
        static let date = "date"
        static let specialEvents = "specialEvents"
    }
    
    case work
    case dailyActivities
    case date
    case specialEvents
    
    init?(rawCode: String) {
        switch rawCode {
        case RawCodes.work:
            self = .work
        case RawCodes.dailyActivities:
            self = .dailyActivities
        case RawCodes.date:
            self = .date
        case RawCodes.specialEvents:
            self = .specialEvents
        default:
            return nil
        }
    }
    
    var rawCode: String {
        switch self {
        case .work:
            return RawCodes.work
        case .dailyActivities:
            return RawCodes.dailyActivities
        case .date:
            return RawCodes.date
        case .specialEvents:
            return RawCodes.specialEvents
        }
    }
}

// MARK: Public (Additional)
extension Occasion {
    struct DefaultLocalized {
        private let occasion: Occasion
        
        init(occasion: Occasion) {
            self.occasion = occasion
        }
        
        var name: String {
            switch occasion {
            case .work:
                return "Occasion.Work".localized
            case .dailyActivities:
                return "Occasion.DailyActivities".localized
            case .date:
                return "Occasion.Date".localized
            case .specialEvents:
                return "Occasion.SpecialEvents".localized
            }
        }
    }
}
