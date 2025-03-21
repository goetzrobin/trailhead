//
//  PhoneSignUpEnterNumberInput.swift
//  trailhead
//
//  Created by Robin Götz on 1/14/25.
//

import Combine
import SwiftUI

struct SignUpEnterNumberInputView: View {
    @Binding var currentCountryCode: PhoneCountryCode
    @Binding var phoneNumber: String
    
    @State var presentSheet = false
    @State private var searchCountry: String = ""

    var filteredCountryCodes: [PhoneCountryCode] {
        if searchCountry.isEmpty {
            return PhoneCountryCode.ALL
        }
        return PhoneCountryCode.ALL.filter { $0.name.contains(searchCountry) }

    }

    var body: some View {
            HStack {
                Button {
                    presentSheet = true
                } label: {
                    Text(
                        "\(self.currentCountryCode.flag) \(self.currentCountryCode.dial_code)"
                    )
                    .inputStyle()
                }

                TextField(
                    "", value: $phoneNumber,
                    formatter: PhoneCountryFormatter(
                        pattern: self.currentCountryCode.pattern)
                )
                .placeholder(when: phoneNumber.isEmpty) {
                    Text("What's your phone number?")
                        .opacity(0.6)
                }
                .keyboardType(.phonePad)
                .inputStyle()
            }
        .sheet(isPresented: $presentSheet) {
            NavigationView {
                List(filteredCountryCodes) { countryCode in
                    HStack {
                        Text(countryCode.flag)
                        Text(countryCode.name)
                            .font(.headline)
                        Spacer()
                        Text(countryCode.dial_code)
                            .foregroundColor(.secondary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        searchCountry = ""
                        self.currentCountryCode = countryCode
                        presentSheet = false
                    }

                }
                .listStyle(.plain)
                .searchable(text: $searchCountry, prompt: "Your country")
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    struct Preview: View {
        @State var number = ""
        @State var currentCountryCode = PhoneCountryCode.US
        var body: some View {
            SignUpEnterNumberInputView(currentCountryCode: $currentCountryCode,
                phoneNumber: $number)
        }
    }

    return Preview()
}
