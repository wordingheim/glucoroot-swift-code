//
//  HomeScreen.swift
//  ML Test
//
//  Created by Minseo Kim on 9/20/24.
//

import SwiftUI
import Charts


class GlobalSelections: ObservableObject {
    @Published var selections: [Float]
    init() {
        self.selections = Array(repeating: -1, count: questionsdict.count)
    }
    func reset() {
        self.selections = Array(repeating: -1, count: questionsdict.count)
    }
}

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
struct PercentKey: EnvironmentKey {
    static let defaultValue: Binding<Double> = .constant(0.0)
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
        get { self[EmailKey.self] }
        set { self[EmailKey.self] = newValue }
    }
    var Percent: Binding<Double> {
        get { self[PercentKey.self] }
        set { self[PercentKey.self] = newValue }
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



struct CV: View {
    @State var isloggedin = false
    @State var username = ""
    @State var password = ""
    @State var name = ""
    @State var email = ""
    @State var percent: Double = 0.0
    @StateObject var globalSelections = GlobalSelections()
    
    
     
    var body: some View {
        NavigationView {
            if isloggedin {
                //HomeScreen(isloggedin:$isloggedin, username:$username)
                HomeScreenTabs()
                    .environment(\.isLoggedIn, $isloggedin)
                    .environment(\.UserName, $username)
                    .environment(\.Name, $name)
                    .environmentObject(globalSelections)
                    .environment(\.Percent, $percent)

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
