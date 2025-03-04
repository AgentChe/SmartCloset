//
//  GlobalDefinitions.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

final class GlobalDefinitions {
    static let domain = "https://closet.korrekted.com"
    static let apiKey = "c3Mtc21hcnQtY2xvc2V0LW5ldy10b2tlbg=="
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "v6yHI2AQpAq7YNYX"
    
    static let applicationTag = "SMART_CLOSET"
    static let amplitudeApiKey = "fbd4c855690516f00baa6b9d7f032e66"
    
    static let termsOfServiceUrl = URL(string: "https://camplain-apps.com/terms-of-use.html")!
    static let privacyPolicyUrl = URL(string: "https://camplain-apps.com/privacy-policy.html")!
    static let contactUsUrl = URL(string: "https://camplain-apps.com/contacts.html")!
    
    enum Paygate {
        static let yearly = "smartcloset.yearly"
        static let weekly = "smartcloset.weekly"
    }
}
