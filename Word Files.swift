//
//  Word Files.swift
//  ML Test
//
//  Created by Minseo Kim on 9/20/24.
//

import SwiftUI



struct resultspage: View {
    var result: Double
    var explanation: String
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            maincolor
                .ignoresSafeArea()
            VStack{
                Text("You have " + String(result) + " risk of diabetes")
                Text(explanation)
            }
            VStack(){
                HStack() {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Manually go back
                    }) {
                        Image("Home")
                    }.padding()
                    Spacer()
                }
                Spacer()
            }
        }.navigationBarBackButtonHidden(true)
        
    }
}
