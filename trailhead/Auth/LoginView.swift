import SwiftUI
import Supabase

struct AuthContainerView: View {
    @Environment(\.dismiss) private var dismiss
    let authStore: AuthStore
    
    var body: some View {
        LoginView(authStore: authStore)
            .background(.clear)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(.clear)
            .presentationBackground(.thinMaterial)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .fontWeight(.medium)
                    }
                    .tint(.primary)
                }
            }
    }
}

struct LoginView: View {
    let authStore: AuthStore
    @State private var showingResetPassword = false
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome back")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom)
            
            Text("Sign in to access your personal journal and continue your journey.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.bottom)
         
            LabeledContent {
                TextField("", text: $email)
                    .inputStyle()
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
            } label: {
                Text("Email address").padding(.leading, 10)
            }
            .labeledContentStyle(.vertical)
            .padding(.bottom, 5)
            
            LabeledContent {
                SecureField("", text: $password)
                    .inputStyle()
                    .textContentType(.password)
            } label: {
                Text("Password").padding(.leading, 10)
            }
            .labeledContentStyle(.vertical)
            .padding(.bottom, 40)
            
            Button {
                Task {
                    await authStore.signIn(email: email, password: password)
                }
            } label: {
                HStack {
                    if authStore.signInStatus == .loading {
                        ProgressView()
                            .frame(width: 23, height: 23)
                            .tint(.black)
                    } else {
                        Text("Continue")
                    }
                }.frame(maxWidth: .infinity)
            }
            .buttonStyle(.jWhite)
            
            Button("Can't sign in?") {
                showingResetPassword = true
            }
            .buttonStyle(.plain)
            .underline()
        }
        .background(.clear)
        .sheet(isPresented: $showingResetPassword) {
            NavigationStack {
                ResetPasswordView(authStore: authStore)
            }
            .presentationBackground(.thinMaterial)
        }
    }
}

struct ResetPasswordView: View {
    let authStore: AuthStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Reset your password")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom)
            
            Text("We'll send you a secure link to create a new password for your account.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.bottom)
            
            LabeledContent {
                TextField("", text: $email)
                    .inputStyle()
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
            } label: {
                Text("Email address").padding(.leading, 10)
            }
            .labeledContentStyle(.vertical)
            .padding(.bottom, 40)
            
            Button {
                Task {
                    await authStore.sendPasswordResetEmail(to: email)
                }
            } label: {
                HStack {
                    if authStore.sendPasswordResetEmailStatus == .loading {
                        ProgressView()
                            .frame(width: 22, height: 22)
                            .tint(.black)
                    } else {
                        Text(authStore.sendPasswordResetEmailStatus == .success(()) ? "Check your inbox!" : "Send reset link")
                    }
                }.frame(maxWidth: .infinity)
            }
            .buttonStyle(.jWhite)
        }
        .padding()
        .background(.clear)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .fontWeight(.medium)
                }
                .tint(.primary)
            }
        }
    }
}

struct LoginContainerView: View {
    @State private var showingAuth = false
    let authStore = AuthStore()
    
    var body: some View {
        Button("Show Auth") {
            showingAuth = true
        }
        .sheet(isPresented: $showingAuth) {
            NavigationStack {
                AuthContainerView(authStore: authStore)
            }
        }
    }
}

#Preview {
    LoginContainerView()
}
