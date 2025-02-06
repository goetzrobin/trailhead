//
//  PhoneSignUpFlowView.swift
//  trailhead
//
//  Created by Robin Götz on 1/24/25.
//

import SwiftUI

struct PhoneSignUpFlowView: View {
    @Environment(AppRouter.self) var router

    let onExit: () -> Void
    let onCodeVerified: () -> Void
    let onFlowComplete: () -> Void

    @State private var phoneSignUpStore = PhoneSignUpStore()

    func setupPhoneSignUpStoreCallbacks() {
        self.phoneSignUpStore.setupCallbacks(
            onCodeSent: {
                self.router.path.append(
                    PhoneSignUpPath.verifyCode
                )
            },
            onCodeVerified: {
                self.router.path.append(
                    PhoneSignUpPath.success
                )
                self.onCodeVerified()
            }
        )
    }

    var body: some View {
        PhoneSignUpWrapperView(
            title: "Nobody likes reading their emails..."
        ) {
            PhoneSignUpEnterNumberView()
        } onExit: {
            self.onExit()
        }
        .environment(self.phoneSignUpStore)
        .onAppear {
            self.setupPhoneSignUpStoreCallbacks()
        }
        .navigationDestination(
            for: PhoneSignUpPath.self
        ) {
            path in
            switch path {
            case .verifyCode:
                PhoneSignUpWrapperView(
                    title: "Did you get your code? Enter it here!"
                ) {
                    PhoneSignUpConfirmCodeView()
                } onExit: {
                    self.onExit()
                } onBack: {
                    self.router.path.removeLast()
                }
                .environment(self.phoneSignUpStore)
            case .success:
                PhoneSignUpSuccessView {
                    self.onFlowComplete()
                }
                .navigationBarBackButtonHidden()
            }
        }

    }

}

#Preview {
    PhoneSignUpFlowView(
        onExit: {
            print("Exiting")
        },
        onCodeVerified: {
            print("Code verified")
        }
    ) {
        print("Flow complete")
    }
}
