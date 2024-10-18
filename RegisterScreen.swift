//
//  RegisterScreen.swift
//  ML Test
//
//  Created by Minseo Kim on 10/3/24.
//
import SwiftUI


struct WelcomeScreen: View {
    //@State private var name: String = ""
    
    @Binding var pagenum: Int
    @Environment(\.Name) var name
    
    var body: some View {
        ZStack {
            secondcolor
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(maincolor)
                            .frame(width: 80, height: 80)
                        Image(systemName: "cpu")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    }
                    
                    Text("Hello, I'm BetaBit.")
                        .font(.system(size: 28, weight: .bold))
                    
                    Text("I'm GlucoRoot's AI assistant, designed to help manage diabetes and trained to be safe, accurate, and secure.")
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("I'd love for us to get to know each other a bit better.")
                        .font(.system(size: 16, weight: .medium))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nice to meet you, I'm...")
                            .font(.system(size: 14, weight: .medium))
                        
                        TextField("Enter your full name", text: name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom)
                    }
                    
                    Button(action: {
                        pagenum = 2
                        print(pagenum)
                    }) {
                        HStack {
                            Text("Let's Begin")
                            Image(systemName: "sparkles")
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(maincolor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    
                    Text("Your health journey begins here. BetaBit is ready to support you every step of the way!")
                        .font(.system(size: 14))
                        .foregroundColor(maincolor)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                }
                .padding()
                .background(Color.white)
                //.cornerRadius(12)
                .shadow(radius: 5)
                .padding()
                
                Spacer()
            }
        }
    }
}




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
                    /*TextField("Full Name", text:$name)
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.leading, .trailing], 20)*/
                    TextField("Username", text:$username)
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.leading, .trailing], 20)
                    TextField("Email", text:$email)
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.leading, .trailing], 20)
                    TextField("Phone", text:$phone)
                        .autocapitalization(.none)
                        .keyboardType(.numberPad) // Show number pad for input
                            .onChange(of: phone) {
                                phone = phone.filter { "0123456789".contains($0) }
                            }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.leading, .trailing], 20)
                    
                    SecureField("Password", text:$password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.leading, .trailing], 20)
                        .textContentType(.oneTimeCode)
                    SecureField("Confirm Password", text:$password2)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.oneTimeCode)
                        .padding([.leading, .trailing], 20)
                    Button(action: {
                        addUser(user:username, pw:password, email:email, name:name, phone:String(phone)) { success in
                            if success {
                                DispatchQueue.main.async {
                                    presentationMode.wrappedValue.dismiss()
                                }
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

struct RS: View{
    @State var pagenum: Int = 1
    var body: some View {
        if pagenum == 1 {
            WelcomeScreen(pagenum: $pagenum)
        } else if pagenum == 2 {
            RegisterScreen()
        }
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        RS()
    }
}
