//
//  CreateAccount.swift
//  DiabetesTest
//
//  Created by Ryan Lien on 10/19/24.
//

import SwiftUI

struct RegistrationScreen: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.05), Color.green.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("Create Your Account")
                        .font(.system(size: 28, weight: .bold))
                    
                    Text("Let's set up your GlucoRoot account so BetaBit can personalize your experience.")
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        InputField(title: "Username", text: $username, placeholder: "Choose a username", systemImage: "person.fill")
                        InputField(title: "Email", text: $email, placeholder: "Enter your email", systemImage: "envelope.fill")
                        InputField(title: "Password", text: $password, placeholder: "Create a password", systemImage: "lock.fill", isSecure: true)
                        InputField(title: "Confirm Password", text: $confirmPassword, placeholder: "Confirm your password", systemImage: "lock.fill", isSecure: true)
                    }
                    
                    Button(action: handleRegister) {
                        Text("Create Account")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Text("By creating an account, you agree to our Terms of Service and Privacy Policy.")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 10)
                .padding()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Registration"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func handleRegister() {
        if password != confirmPassword {
            alertMessage = "Passwords do not match."
        } else if username.isEmpty || email.isEmpty || password.isEmpty {
            alertMessage = "Please fill in all fields."
        } else {
            alertMessage = "Account created successfully! Welcome to GlucoRoot, \(username)!"
        }
        showAlert = true
    }
}

struct InputField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let systemImage: String
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
            HStack {
                Image(systemName: systemImage)
                    .foregroundColor(.green)
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.green.opacity(0.5), lineWidth: 1)
            )
        }
    }
}

struct RegistrationScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationScreen()
            .previewLayout(.sizeThatFits) // This line can help
            .padding()
    }
}

