//
//  Profile.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 24.01.2025.
//

import Foundation

struct Profile {
    let name: String?
    let avatar: URL?
    let size: Size?
    let gender: Gender?
    let height: Height?
    let interestedColors: [String]?
    let occasions: [Occasion]?
    let season: Season?
}

// MARK: Public
extension Profile {
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any]
        else { return nil }
        
        self.name = body["name"] as? String
        self.avatar = {
            guard let string = body["avatar"] as? String else { return nil }
            return URL(string: string)
        }()
        self.size = {
            guard let rawCode = body["size"] as? String else { return nil }
            return Size(rawCode: rawCode)
        }()
        self.gender = {
            guard let rawCode = body["sex"] as? String else { return nil }
            return Gender(rawCode: rawCode)
        }()
        self.height = {
            guard
                let heightValue = body["height"] as? Double,
                let unitRawValue = body["height_unit"] as? String,
                let unit = HeightUnit(rawCode: unitRawValue)
            else { return nil }
            
            return Height(value: heightValue, unit: unit)
        }()
        self.interestedColors = body["interested_color"] as? [String]
        self.occasions = {
            guard let rawCodes = body["occasion"] as? [String] else { return nil }
            return rawCodes.compactMap { Occasion(rawCode: $0) }
        }()
        self.season = {
            guard let rawCodes = body["seasons"] as? [String] else { return nil }
            return rawCodes.compactMap { Season(rawCodes: $0) }.first
        }()
    }
}
