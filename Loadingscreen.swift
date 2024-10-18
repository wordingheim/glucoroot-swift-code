//
//  Loadingscreen.swift
//  ML Test
//
//  Created by Minseo Kim on 10/16/24.
//

import SwiftUI



struct AnimatedBackground: View {
    var body: some View {
        ZStack {
            Color.green.opacity(0.1)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct LoadingScreen: View {
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            secondcolor
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("GlucoRoot")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(maincolor)
                
                Text("Tailored care for every individual")
                    .font(.subheadline)
                    .foregroundColor(maincolor)
                
                ZStack {
                    Circle()
                        .stroke(Color.green.opacity(0.3), lineWidth: 4)
                        .frame(width: 50, height: 50)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(maincolor, lineWidth: 6)
                        .frame(width: 50, height: 50)
                        .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                        .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isLoading)
                }
                .padding(.top, 20)
            }
        }
        .onAppear {
            isLoading = true
        }
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
    }
}
