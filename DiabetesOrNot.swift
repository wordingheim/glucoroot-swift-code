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
        NavigationView {
            ScrollView {
                VStack {
                    Spacer(minLength: 20)
                    
                    statusSelectionCard
                        .padding(.horizontal)
                        .frame(maxWidth: 500) // Limit maximum width for larger screens
                    
                    Spacer(minLength: 20)
                }
            }
            .navigationTitle("Welcome")
            .background(secondcolor.edgesIgnoringSafeArea(.all))
        }
    }
    
    var statusSelectionCard: some View {
        VStack(spacing: 25) {
            VStack(spacing: 12) {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(maincolor)
                    .padding(.bottom, 5)
                
                Text("Your Diabetes Status")
                    .font(.title2)
                    .bold()
                    .foregroundColor(maincolor)
                
                Text("Please select the option that best describes you")
                    .font(.body)
                    .foregroundColor(textcolor.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 10)
            
            VStack(spacing: 15) {
                StatusButton(title: "I Have Diabetes",
                           icon: "cross.case.fill",
                           action: { self.hasDiabetes = true })
                
                StatusButton(title: "Take Risk Assessment",
                           icon: "clipboard.fill",
                           action: { self.hasDiabetes = false })
            }
            .padding(.horizontal, 5)
            
            Text("Your selection helps us personalize your experience")
                .font(.subheadline)
                .foregroundColor(textcolor.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
        }
        .padding(20)
        .background(thirdcolor)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(bordercolor, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct StatusButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                
                Text(title)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(maincolor)
            .foregroundColor(thirdcolor)
            .cornerRadius(12)
        }
    }
}

struct DiabetesStatusSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DiabetesStatusSelectionView()
    }
}
