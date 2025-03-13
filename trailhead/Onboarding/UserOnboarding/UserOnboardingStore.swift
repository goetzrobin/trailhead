//
//  UserOnboardingStore.swift
//  trailhead
//
//  Created by Robin Götz on 1/15/25.
//

import Foundation

// Model representing the possible group options
struct OnboardingOption: Identifiable, Equatable {
    var id: String { value }
    let type: String  // 'fixed' or 'custom'
    let value: String
    let label: String

    static func == (lhs: OnboardingOption, rhs: OnboardingOption) -> Bool {
        return lhs.value == rhs.value
    }
}

let COHORT_OPTIONS: [OnboardingOption] = [
    OnboardingOption(
        type: "fixed", value: "current-athlete",
        label: "Current student-athlete"),
    OnboardingOption(
        type: "fixed", value: "current-sthm",
        label: "Current Temple STHM undergraduate student"),
    OnboardingOption(
        type: "fixed", value: "former-athlete-current-mssb",
        label: "Current Temple MSSB student"),
    OnboardingOption(
        type: "fixed", value: "former-athlete-non-mssb",
        label: "Former student-athlete (non-MSSB student)"),
    OnboardingOption(type: "custom", value: "other", label: "Other"),
]

let ETHNICITY_OPTIONS: [OnboardingOption] =
[
    OnboardingOption(
        type: "fixed", value: "american-indian-or-alaska-native",
        label: "American Indian or Alaska Native"),
    OnboardingOption(type: "fixed", value: "asian", label: "Asian"),
    OnboardingOption(
        type: "fixed", value: "black-or-african-american",
        label: "Black or African American"),
    OnboardingOption(
        type: "fixed", value: "hispanic/latino/latina",
        label: "Hispanic/Latino/Latina"),
    OnboardingOption(
        type: "fixed", value: "white/caucasian", label: "White/Caucasian"),
    OnboardingOption(
        type: "fixed", value: "native-hawaiian-or-other-pacific-islander",
        label: "Native Hawaiian or other Pacific Islander"),
    OnboardingOption(
        type: "custom", value: "biracial-or-multiracial",
        label: "Biracial or Multiracial"),
    OnboardingOption(
        type: "custom", value: "prefer-to-self-describe",
        label: "Prefer to self describe"),
    OnboardingOption(
        type: "fixed", value: "prefer-not-to-say",
        label: "Prefer not to say"),
]

let GENDER_OPTIONS: [OnboardingOption] = [
    OnboardingOption(type: "fixed", value: "woman", label: "Woman"),
    OnboardingOption(type: "fixed", value: "man", label: "Man"),
    OnboardingOption(
        type: "fixed", value: "transgender man", label: "Transgender man"),
    OnboardingOption(
        type: "fixed", value: "transgender woman", label: "Transgender woman"),
    OnboardingOption(type: "fixed", value: "non-binary", label: "Non Binary"),
    OnboardingOption(
        type: "custom", value: "prefer-to-self-describe",
        label: "Prefer to self describe"),
    OnboardingOption(
        type: "fixed", value: "prefer-not-to-say", label: "Prefer not to say"),
]

let COMP_LEVEL_OPTIONS: [OnboardingOption] = [
    OnboardingOption(
        type: "fixed", value: "youth-rec", label: "Youth/Recreational Sport"),
    OnboardingOption(
        type: "fixed", value: "high-school", label: "High School Sport"),
    OnboardingOption(type: "fixed", value: "college", label: "College Sport"),
]

let DIVISION_OPTIONS: [OnboardingOption] = [
    OnboardingOption(type: "fixed", value: "D1", label: "NCAA Division I"),
    OnboardingOption(type: "fixed", value: "D2", label: "NCAA Division II"),
    OnboardingOption(type: "fixed", value: "D3", label: "NCAA Division III"),
    OnboardingOption(type: "custom", value: "other", label: "Other"),
]


@Observable class UserOnboardingStore {
    var name: String = ""
    var pronouns: String = ""
    var birthday: Date = {
        let today = Date()
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: today)
        let currentDay = calendar.component(.day, from: today)
    
        return calendar.date(
            from: DateComponents(
                year: 2000,
                month: currentMonth,
                day: currentDay
            )
        )!
    }()
    var currentAge: Int {
        Calendar.current.dateComponents([.year], from: birthday, to: Date())
            .year ?? 0
    }

    var graduationYear = 2025
    
    var referredBy = ""

    var selectedCohort: OnboardingOption?
    var customCohort: String?

    var selectedGenderIdentity: OnboardingOption?
    var customGenderIdentity: String?

    var selectedEthnicity: OnboardingOption?
    var customEthnicity: String?

    var selectedCompetitionLevel: OnboardingOption?

    var selectedNcaaDivision: OnboardingOption?
    var customNcaaDivision: String?

    var data: UserUpdateData {
        var cohort = ""
        // Handle cohort data
        if let selectedCohort = selectedCohort {
            if selectedCohort.type == "custom" && customCohort != nil {
                cohort = customCohort!
            } else {
                cohort = selectedCohort.value
            }
        }

        var genderIdentity = ""
        // Handle gender identity data
        if let selectedGenderIdentity = selectedGenderIdentity {
            if selectedGenderIdentity.type == "custom"
                && customGenderIdentity != nil
            {
                genderIdentity = customGenderIdentity!
            } else {
                genderIdentity = selectedGenderIdentity.value
            }
        }

        var ethnicity = ""
        // Handle ethnicity data
        if let selectedEthnicity = selectedEthnicity {
            if selectedEthnicity.type == "custom" && customEthnicity != nil {
                ethnicity = customEthnicity!
            } else {
                ethnicity = selectedEthnicity.value
            }
        }

        var competitionLevel = ""
        // Handle competition level data
        if let selectedCompetitionLevel = selectedCompetitionLevel {
            competitionLevel = selectedCompetitionLevel.value
        }

        var ncaaDivision = ""
        // Handle NCAA division data
        if let selectedNcaaDivision = selectedNcaaDivision {
            if selectedNcaaDivision.type == "custom"
                && customNcaaDivision != nil
            {
                ncaaDivision = customNcaaDivision!
            } else {
                ncaaDivision = selectedNcaaDivision.value
            }
        }

        return UserUpdateData(
            name: name, pronouns: pronouns, birthday: birthday,
            graduationYear: graduationYear, cohort: cohort,
            genderIdentity: genderIdentity, ethnicity: ethnicity,
            competitionLevel: competitionLevel, ncaaDivision: ncaaDivision)
    }
}
