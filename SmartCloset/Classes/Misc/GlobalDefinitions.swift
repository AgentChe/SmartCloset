//
//  GlobalDefinitions.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

final class GlobalDefinitions {
    static let domain = "https://closet.thinkaboutapps.com"
    static let apiKey = "c3Mtc21hcnQtY2xvc2V0LW5ldy10b2tlbg=="
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "v6yHI2AQpAq7YNYX"
    
    static let termsOfServiceUrl = URL(string: "https://thinkaboutapps.com/terms")!
    static let privacyPolicyUrl = URL(string: "https://thinkaboutapps.com/policy")!
    static let contactUsUrl = URL(string: "https://thinkaboutapps.com/contact")!
    
    enum Paygate {
        static let yearly = "smartcloset.yearly"
        static let weekly = "smartcloset.weekly"
    }
}
