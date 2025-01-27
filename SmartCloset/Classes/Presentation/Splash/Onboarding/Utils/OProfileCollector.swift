//
//  OProfileCollector.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 27.01.2025.
//

import Foundation

final class OProfileCollector {
    private var name: String?
    private var avatar: URL?
    private var size: Size?
    private var gender: Gender?
    private var height: Height?
    private var interestedColors: [String]?
    private var occasions: [Occasion]?
    private var seasons: [Season]?
}

// MARK: Public
extension OProfileCollector {
    func setup(name: String?) {
        self.name = name
    }
    
    func setup(avatar: URL?) {
        self.avatar = avatar
    }
    
    func setup(size: Size?) {
        self.size = size
    }
    
    func setup(gender: Gender?) {
        self.gender = gender
    }
    
    func setup(height: Height?) {
        self.height = height
    }
    
    func setup(interestedColors: [String]?) {
        self.interestedColors = interestedColors
    }
    
    func setup(occasions: [Occasion]?) {
        self.occasions = occasions
    }
    
    func setup(seasons: [Season]?) {
        self.seasons = seasons
    }
    
    func make() -> Profile {
        Profile(
            name: name,
            avatar: avatar,
            size: size,
            gender: gender,
            height: height,
            interestedColors: interestedColors,
            occasions: occasions,
            seasons: seasons
        )
    }
}
