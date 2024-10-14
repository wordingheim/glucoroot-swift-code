//
//  HomeScreen.swift
//  ML Test
//
//  Created by Minseo Kim on 9/20/24.
//

import SwiftUI
import Charts


struct LoggedInKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false) // Default to a constant Binding
}
struct NameKey: EnvironmentKey {
    static let defaultValue: Binding<String> = .constant("") // Default to a constant Binding
}
struct UserNameKey: EnvironmentKey {
    static let defaultValue: Binding<String> = .constant("")
}
struct EmailKey: EnvironmentKey {
    static let defaultValue: Binding<String> = .constant("")
}

extension EnvironmentValues {
    var isLoggedIn: Binding<Bool> {
        get { self[LoggedInKey.self] }
        set { self[LoggedInKey.self] = newValue }
    }
    
    var Name: Binding<String> {
        get { self[NameKey.self] }
        set { self[NameKey.self] = newValue }
    }
    var UserName: Binding<String> {
        get { self[UserNameKey.self] }
        set { self[UserNameKey.self] = newValue }
    }
    var Email: Binding<String> {
        get { self[UserNameKey.self] }
        set { self[UserNameKey.self] = newValue }
    }
}


struct HomeScreen: View{
    @Binding var isloggedin: Bool
    @Binding var username: String
    var body: some View {
        ZStack {
            maincolor
                .ignoresSafeArea()
            VStack {
                Text("Welcome, " + username)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
                
                    
            }
            VStack {
                
                Button(action: {
                    
                }) {
                    Text("PROFILE")
                }
                
                NavigationLink(destination: Questions(
                    //questions: q_v, answers: answerssample
                    questionsframe:questionsdict
                )) {
                Text("this survey")
                }
                NavigationLink(destination: resultspage(result:result, explanation: explanation)) {
                Text("read results")
                }
                
            }
            VStack(spacing:0) {
                Spacer()
                Rectangle()
                    .fill(secondcolor)
                    .frame(height:80)
                    .overlay(
                        VStack{
                            Button(action:{
                                logout() {success in
                                    if success == true {
                                        isloggedin = false
                                        username = ""
                                    }
                                }
                            }) {
                                Text("LOGOUT")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(maincolor)
                                    
                            }.padding()
                            Spacer()
                        }
                        
                    )
                    
            }.ignoresSafeArea(edges: .bottom)
        }
    }
}

struct LoginScreen: View {
    //@Binding var isloggedin: Bool
    //@Binding var username: String
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
                    
                    NavigationLink(destination:RegisterScreen()) {
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

struct CV: View {
    @State var isloggedin = false
    @State var username = ""
    @State var password = ""
    @State var name = ""
    @State var email = ""
    
    
    
     
    var body: some View {
        NavigationView {
            if isloggedin {
                //HomeScreen(isloggedin:$isloggedin, username:$username)
                HomeScreenTabs()
                    .environment(\.isLoggedIn, $isloggedin)
                    .environment(\.UserName, $username)
                    .environment(\.Name, $name)

            } else {
                LoginScreen()
                    .environment(\.isLoggedIn, $isloggedin)
                    .environment(\.UserName, $username)
                    .environment(\.Name, $name)
                    .environment(\.Email, $email)
            }
        }
        
    }
}

#Preview {
    CV()
}
