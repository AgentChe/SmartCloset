//
//  XOREncryption.swift
//  Soccer
//
//  Created by Андрей Чернышев on 11.03.2022.
//

import Foundation

final class XOREncryption {
    static func encryptDecrypt(_ input: String, key: String) -> String? {
        let keyArr = Array(key)
        let decodedArr = Array(input)
        var result = ""

        for i in 0..<decodedArr.count {
            let keyChar = keyArr[i % keyArr.count]
            let decodedChar = decodedArr[i]
            
            let xorValue = decodedChar.unicodeScalars.first!.value ^ keyChar.unicodeScalars.first!.value
            if let scalar = UnicodeScalar(xorValue) {
                result.append(Character(scalar))
            }
        }
        
        return result
    }
    
    static func toJSON(_ input: String, key: String) -> [String: Any]? {
        guard
            let base64 = input.base64Decoded(),
            let encryptDecrypt = encryptDecrypt(base64, key: key),
            let data = encryptDecrypt.data(using: .utf8)
        else { return nil }
        
        return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    }
}
