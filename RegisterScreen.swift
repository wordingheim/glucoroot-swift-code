//
//  RegisterScreen.swift
//  ML Test
//
//  Created by Minseo Kim on 10/3/24.
//
import SwiftUI
struct RegisterScreen: View {
    @State var name: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State var password2: String = ""
    @State var phone: String = ""
    @State var email: String = ""

    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            secondcolor
                .ignoresSafeArea()
            VStack{
                Text("GlucoRoot")
                    .font(.largeTitle)
                    .foregroundColor(maincolor)
                    .fontWeight(.bold)
                
                VStack {
                    TextField("Full Name", text:$name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.leading, .trailing], 20)
                    TextField("Email", text:$email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.leading, .trailing], 20)
                    TextField("Phone", text:$phone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.leading, .trailing], 20)
                    TextField("Username", text:$username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.leading, .trailing], 20)
                    SecureField("Password", text:$password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.leading, .trailing], 20)
                    SecureField("Confirm Password", text:$password2)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.leading, .trailing], 20)
                    Button(action: {
                        addUser(user:username, pw:password, email:email, name:name) { success in
                            if success {
                                password = ""
                                password2 = ""
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        
                        
                    }) {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height:36)
                            .foregroundColor(.white)
                            .background(maincolor)
                            .cornerRadius(6)
                            .padding([.leading, .trailing], 20)
                    }
                    
                    HStack {
                        Text("Already have an account? ")
                            .font(.caption)
                        Text("Log In")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(maincolor)
                            .onTapGesture {
                                print("Register tapped")
                                presentationMode.wrappedValue.dismiss()
                            }
                        
                    }.padding(5)
                }
                .frame(width:300, height:400)
                .background(Color.white)
                .cornerRadius(10)
                
                
                
            }
                
        }
        .navigationBarBackButtonHidden(true) // Hide default back button
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Manual back action
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(maincolor)
                            Text("Back")
                                .foregroundColor(maincolor)
                        }
                    }
                }
            }
    }
}
