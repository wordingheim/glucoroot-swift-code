//
//  CreateAccount.swift
//  DiabetesTest
//
//  Created by Ryan Lien on 10/19/24.
//

import SwiftUI

struct CreateAccountView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showingSuccessMessage = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Section
                    VStack(spacing: 8) {
                        Text("Create Your Account")
                            .font(.title)
                            .bold()
                            .foregroundColor(maincolor)
                        
                        Text("Let's set up your GlucoRoot account so that BetaBit can personalize your experience.")
                            .font(.subheadline)
                            .foregroundColor(textcolor)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Form Fields
                    VStack(spacing: 20) {
                        // Username Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Username")
                                .font(.headline)
                                .foregroundColor(maincolor)
                            
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(maincolor)
                                    .frame(width: 20)
                                    .padding(.leading, 8)
                                
                                TextField("Enter username", text: $username)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(textcolor)
                                    .padding(.vertical, 8)
                            }
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(bordercolor, lineWidth: 1))
                        }
                        .padding()
                        .background(thirdcolor)
                        .cornerRadius(15)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(bordercolor, lineWidth: 1))
                        
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.headline)
                                .foregroundColor(maincolor)
                            
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(maincolor)
                                    .frame(width: 20)
                                    .padding(.leading, 8)
                                
                                TextField("Enter email", text: $email)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(textcolor)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .padding(.vertical, 8)
                            }
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(bordercolor, lineWidth: 1))
                        }
                        .padding()
                        .background(thirdcolor)
                        .cornerRadius(15)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(bordercolor, lineWidth: 1))
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.headline)
                                .foregroundColor(maincolor)
                            
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(maincolor)
                                    .frame(width: 20)
                                    .padding(.leading, 8)
                                
                                SecureField("Enter password", text: $password)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(textcolor)
                                    .padding(.vertical, 8)
                            }
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(bordercolor, lineWidth: 1))
                        }
                        .padding()
                        .background(thirdcolor)
                        .cornerRadius(15)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(bordercolor, lineWidth: 1))
                        
                        // Confirm Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm Password")
                                .font(.headline)
                                .foregroundColor(maincolor)
                            
                            HStack {
                                Image(systemName: "lock.shield.fill")
                                    .foregroundColor(maincolor)
                                    .frame(width: 20)
                                    .padding(.leading, 8)
                                
                                SecureField("Confirm your password", text: $confirmPassword)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(textcolor)
                                    .padding(.vertical, 8)
                            }
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(bordercolor, lineWidth: 1))
                        }
                        .padding()
                        .background(thirdcolor)
                        .cornerRadius(15)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(bordercolor, lineWidth: 1))
                        
                        // Create Account Button
                        Button(action: createAccount) {
                            Text("Create Account")
                                .foregroundColor(thirdcolor)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(maincolor)
                                .cornerRadius(10)
                        }
                        .padding(.top)
                    }
                    .padding()
                }
            }
            .background(secondcolor.opacity(0.6).edgesIgnoringSafeArea(.all))
            .overlay(
                // Success Message Popup
                ZStack {
                    if showingSuccessMessage {
                        VStack {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Account Created Successfully")
                                    .foregroundColor(.white)
                                    .font(.headline)
                            }
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                        }
                        .transition(.move(edge: .top))
                        .animation(.easeInOut)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showingSuccessMessage = false
                                }
                            }
                        }
                    }
                }
                .padding(.top, 20)
                , alignment: .top
            )
        }
    }
    
    func createAccount() {
        // Add account creation logic here
        
        // Show success message
        withAnimation {
            showingSuccessMessage = true
        }
        
        // Reset form
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            username = ""
            email = ""
            password = ""
            confirmPassword = ""
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
