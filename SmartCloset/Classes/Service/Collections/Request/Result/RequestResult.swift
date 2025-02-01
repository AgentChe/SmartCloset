//
//  RequestResult.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 31.01.2025.
//

struct RequestResult {
    let success: Bool
}

// MARK: Public
extension RequestResult {
    static func map(response: Any) -> RequestResult {
        guard let json = response as? [String: Any] else {
            return RequestResult(success: false)
        }
        
        let success: Bool = {
            guard
                let errorJSON = json["error"] as? [String: Any],
                let errorMessage = errorJSON["message"] as? String
            else { return true }
            
            return errorMessage.isEmpty
        }()
        
        return RequestResult(success: success)
    }
}
