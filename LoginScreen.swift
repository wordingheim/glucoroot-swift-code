//
//  LoginScreen.swift
//  ML Test
//
//  Created by Minseo Kim on 10/14/24.
//
import SwiftUI
struct LoginScreen: View {
    @State var password: String = ""
    @State private var showPopup = false
    
    @Environment(\.isLoggedIn) var ilg
    @Environment(\.UserName) var usr
    @Environment(\.Name) var name
    @Environment(\.Email) var email
    
    var body: some View {
        ZStack {
            secondcolor
                .ignoresSafeArea()
           
            VStack {
                Text("GlucoRoot")
                    .font(.largeTitle)
                    .foregroundColor(maincolor)
                    .fontWeight(.bold)
                
                TextField("Username", text:usr)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.leading, .trailing], 20)
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.leading, .trailing], 20)
                Button(action: {
                    login(user:usr.wrappedValue, pw:password) { success, lst in
                        if success {
                            print(lst)
                            ilg.wrappedValue = true
                            name.wrappedValue = lst[0]
                            usr.wrappedValue = lst[1]
                            email.wrappedValue = lst[2]
                            password = ""
                        } else {
                            showPopup = true
                            hidePopupAfterDelay()
                        }
                    }
                    
                }) {
                    Text("Log In")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height:36)
                        .foregroundColor(.white)
                        .background(maincolor)
                        .cornerRadius(6)
                        .padding([.leading, .trailing], 20)
                }
                
                HStack {
                    Text("Don't have an account? ")
                        .font(.caption)
                    
                    NavigationLink(destination:RS()) {
                        Text("Register")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(maincolor)
                    }
                    
                }.padding(5)
            }
            .padding(.vertical, 40) // Add padding inside the box
            .background(
                Rectangle()
                    .fill(Color.white) // White box
                    .shadow(radius: 5) // Optional: Add a shadow to the box
            )
            .padding(.horizontal)
            
                
            if showPopup {
                PopupView(txt:"Invalid username/password combination")
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
    }
    
    func hidePopupAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                showPopup = false
            }
        }
    }
}

struct PopupView: View {
    var txt : String
    var body: some View {
        VStack {
            Text(txt)
                .padding()
                .background(Color.white)
                .shadow(radius:5)
        }
    }
}
