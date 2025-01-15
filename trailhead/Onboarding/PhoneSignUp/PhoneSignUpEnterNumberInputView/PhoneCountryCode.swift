//
//  PhoneCountryCode.swift
//  trailhead
//
//  Created by Robin Götz on 1/14/25.
//

import Foundation

struct PhoneCountryCode: Codable, Identifiable {
    let id: String
    let name: String
    let flag: String
    let code: String
    let dial_code: String
    let pattern: String
    let limit: Int
    
    static let ALL: [PhoneCountryCode] = Bundle.main.decode("PhoneCountryCodes.json")
    static var US: PhoneCountryCode{ ALL.first(where: { $0.code == "US" })! }
}
