//
//  GlobalDefinitions.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

// TODO
final class GlobalDefinitions {
    static let domain = "https://skin.thinkaboutapps.com"
    static let apiKey = "K9tK6iIQ4mZZNnWhs9c9y3DI"
    
    static let dermatologyDomain = "https://dermatology.awesum-apps.com"
    static let dermatologyApiKey = "7LexM8IGOSmIrpEimANw"
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "6ShpjkA5kIKzBA48"
    
    static let applicationTag = "SCIENCE_SOLVER"
    static let amplitudeApiKey = "d433d2c66723aeefd10c5b65f91c1fa3"
    
    static let termsOfServiceUrl = URL(string: "https://camplain-apps.com/terms-of-use.html")!
    static let privacyPolicyUrl = URL(string: "https://camplain-apps.com/privacy-policy.html")!
    static let contactUsUrl = URL(string: "https://camplain-apps.com/contacts.html")!
    
    enum Paygate {
        static let yearly = "app.iphone.tracker.lifetime"
        static let weekly = "app.iphone.tracker.monthly"
    }
}
