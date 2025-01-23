//
//  PhoneSignUpStore.swift
//  trailhead
//
//  Created by Robin Götz on 1/15/25.
//

import Foundation

@Observable class UserOnboardingStore {
    var name: String = ""
    var pronouns: String = ""
    var birthday: Date = Calendar.current.date(from: DateComponents(year: 2000, month: 1, day: 1))!
    var currentAge: Int {
           Calendar.current.dateComponents([.year], from: birthday, to: Date()).year ?? 0
       }
}
