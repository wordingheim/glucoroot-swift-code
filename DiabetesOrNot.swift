//
//  DiabetesOrNot.swift
//  DiabetesTest
//
//  Created by Ryan Lien on 10/19/24.
//

import SwiftUI

struct DiabetesStatusSelectionView: View {
    @State private var hasDiabetes: Bool?

    var body: some View {
        ZStack {
            Color(red: 240/255, green: 255/255, blue: 240/255)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Card {
                    VStack(spacing: 20) {
                        Text("Your Diabetes Status")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color.green)

                        Text("Please select the option that best describes you:")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Button("I have diabetes") {
                            self.hasDiabetes = true
                            print("User has diabetes")
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        
                        Button("I want to take the diabetes risk assessment") {
                            self.hasDiabetes = false
                            print("User wants risk assessment")
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .background(Color(red: 220/255, green: 252/255, blue: 231/255))

                        Text("Your selection helps us personalize your experience")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
                .frame(maxWidth: 400)
            }
        }
    }
}

struct Card<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2))
    }
}

struct DiabetesStatusSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DiabetesStatusSelectionView()
            DiabetesStatusSelectionView().preferredColorScheme(.dark)
        }
    }
}
