//
//  NursingNavigationControllerSettings.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

struct NavigationControllerSettings {
    let backgroundImage: UIImage
    let shadowImage: UIImage
    let isTranslucent: Bool
    let tintColor: UIColor
    let titleTextAttrributes: [NSAttributedString.Key: Any]
}

// MARK: Make
extension NavigationControllerSettings {
    static func `default`() -> NavigationControllerSettings {
        NavigationControllerSettings(backgroundImage: UIImage(),
                                     shadowImage: UIImage(),
                                     isTranslucent: true,
                                     tintColor: Appearance.main1,
                                     titleTextAttrributes: TextAttributes()
                                        .textColor(Appearance.main1)
                                        .font(Fonts.SofiaSans.medium(size: 17.scale))
                                        .textAlignment(.center)
                                        .dictionary)
    }
}
