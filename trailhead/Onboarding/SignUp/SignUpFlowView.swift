//
//  PhoneSignUpFlowView.swift
//  trailhead
//
//  Created by Robin Götz on 1/24/25.
//

import SwiftUI

struct SignUpFlowView: View {
    let auth: AuthStore
    let router: AppRouter
    let onExit: () -> Void
    let onSignUpSuccess: () -> Void
    let onFlowComplete: () -> Void

    @State private var signUpStore: SignUpStore
    
    init(auth: AuthStore, router: AppRouter, onExit: @escaping () -> Void, onSignUpSuccess: @escaping () -> Void, onFlowComplete: @escaping () -> Void) {
        self.auth = auth
        self.router = router
        self.onExit = onExit
        self.onSignUpSuccess = onSignUpSuccess
        self.onFlowComplete = onFlowComplete
        self.signUpStore = SignUpStore(auth: auth)
    }

    func setupSignUpStoreCallbacks() {
        self.signUpStore.setupCallbacks(
            onSignUpSuccess: {
                self.router.path.append(
                    SignUpPath.success
                )
                self.onSignUpSuccess()
            }
        )
    }

    var body: some View {
        SignUpWrapperView(
            title: "Let's start your journey!"
        ) {
            SignUpCreateAccountView()
        } onExit: {
            self.onExit()
        }
        .environment(self.signUpStore)
        .onAppear {
            self.setupSignUpStoreCallbacks()
        }
        .navigationDestination(
            for: SignUpPath.self
        ) {
            path in
            switch path {
            case .success:
                SignUpSuccessView {
                    self.onFlowComplete()
                }
                .navigationBarBackButtonHidden()
            }
        }

    }

}

#Preview {
    @Previewable @State var router = AppRouter()
    NavigationStack {
        SignUpFlowView(
            auth: AuthStore(),
            router: router,
            onExit: {
                print("Exiting")
            },
            onSignUpSuccess: {
                print("Sign up success")
            }
        ) {
            print("Flow complete")
        }
    }
}
