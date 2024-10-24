//
//  ChatbotIntroduction.swift
//  DiabetesTest
//
//  Created by Ryan Lien on 10/24/24.
//

import SwiftUI

struct AIIntroductionScreen: View {
    @State private var currentStep = 0
    @State private var fadeIn = false
    @State private var avatarOffset: CGFloat = 50
    @State private var textOffset: CGFloat = 30
    @State private var showContent = false
    @State private var shouldNavigateToChat = false

    private let steps = 4
    
    var body: some View {
        NavigationView {
            ZStack {
                secondcolor.opacity(0.3).edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Avatar Section
                        Image("AI_ChatbotAvatar1")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(maincolor, lineWidth: 2))
                            .shadow(radius: 10)
                            .offset(y: avatarOffset)
                            .opacity(fadeIn ? 1 : 0)
                        
                        // Content based on current step
                        VStack(spacing: 20) {
                            switch currentStep {
                            case 0:
                                introductionContent
                            case 1:
                                capabilitiesContent
                            case 2:
                                sampleConversationContent
                            case 3:
                                getFeaturesStarted
                            default:
                                EmptyView()
                            }
                        }
                        .offset(y: textOffset)
                        .opacity(showContent ? 1 : 0)
                        
                        Spacer(minLength: 50)
                    }
                    .padding()
                }
                
                // Bottom Navigation
                VStack {
                    Spacer()
                    bottomNavigation
                }
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    // MARK: - Step Content Views
    
    private var introductionContent: some View {
        VStack(spacing: 25) {
            Text("Hello, I'm Alex")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(maincolor)
            
            Text("Your personal AI diabetes management assistant")
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(textcolor)
            
            Text("I'm here to help you manage your diabetes journey with personalized support and guidance.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(textcolor)
                .padding(.horizontal)
        }
    }
    
    private var capabilitiesContent: some View {
        VStack(spacing: 25) {
            Text("What I Can Help You With")
                .font(.title2)
                .bold()
                .foregroundColor(maincolor)
            
            CapabilityCard(icon: "pills", title: "Medication Tracking", description: "I'll help you stay on top of your medication schedule")
            CapabilityCard(icon: "chart.line.uptrend.xyaxis", title: "Glucose Monitoring", description: "Track and analyze your glucose levels")
            CapabilityCard(icon: "fork.knife", title: "Diet Guidance", description: "Personalized meal suggestions and carb counting")
            CapabilityCard(icon: "figure.walk", title: "Activity Tracking", description: "Exercise recommendations and tracking")
        }
    }
    
    private var sampleConversationContent: some View {
        VStack(spacing: 25) {
            Text("Let's Chat!")
                .font(.title2)
                .bold()
                .foregroundColor(maincolor)
            
            VStack(spacing: 15) {
                ChatBubblePreview(message: "Can you remind me to take my insulin?", isUser: true)
                ChatBubblePreview(message: "Of course! I'll set up a reminder for your insulin. What time would you like to be reminded?", isUser: false)
                ChatBubblePreview(message: "How's my glucose trending this week?", isUser: true)
                ChatBubblePreview(message: "I'll analyze your glucose data and show you the trends right away!", isUser: false)
            }
        }
    }
    
    private var getFeaturesStarted: some View {
        VStack(spacing: 25) {
            Text("Ready to Get Started?")
                .font(.title2)
                .bold()
                .foregroundColor(maincolor)
            
            Text("I'm here to support you 24/7 with:")
                .foregroundColor(textcolor)
            
            FeatureList(features: [
                "Personalized reminders",
                "Blood glucose tracking",
                "Medication management",
                "Diet and exercise guidance",
                "Real-time support"
            ])
            
            Button(action: {
                shouldNavigateToChat = true
            }) {
                Text("Start Chatting with Alex")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(maincolor)
                    .cornerRadius(15)
            }
            .padding(.top)
        }
    }
    
    // MARK: - Supporting Views
    
    private var bottomNavigation: some View {
        VStack {
            // Progress Dots
            HStack(spacing: 8) {
                ForEach(0..<steps) { step in
                    Circle()
                        .fill(step == currentStep ? maincolor : maincolor.opacity(0.3))
                        .frame(width: 10, height: 10)
                }
            }
            .padding()
            
            // Navigation Buttons
            HStack {
                if currentStep > 0 {
                    Button("Back") {
                        withAnimation {
                            currentStep -= 1
                        }
                    }
                    .foregroundColor(maincolor)
                }
                
                Spacer()
                
                if currentStep < steps - 1 {
                    Button("Next") {
                        withAnimation {
                            currentStep += 1
                        }
                    }
                    .foregroundColor(maincolor)
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 20)
        }
        .background(thirdcolor.opacity(0.9))
    }
    
    // MARK: - Animations
    
    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.8)) {
            fadeIn = true
            avatarOffset = 0
        }
        
        withAnimation(.easeOut(duration: 0.8).delay(0.4)) {
            textOffset = 0
            showContent = true
        }
    }
}

// MARK: - Supporting Components

struct CapabilityCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(maincolor)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(textcolor)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(textcolor.opacity(0.8))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(thirdcolor)
        .cornerRadius(15)
        .shadow(radius: 2)
    }
}

struct ChatBubblePreview: View {
    let message: String
    let isUser: Bool
    
    var body: some View {
        HStack {
            if isUser { Spacer() }
            
            if !isUser {
                Image("AI_ChatbotAvatar")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            }
            
            Text(message)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isUser ? maincolor : secondcolor.opacity(0.3))
                .foregroundColor(isUser ? .white : textcolor)
                .cornerRadius(20)
            
            if !isUser { Spacer() }
        }
        .padding(.horizontal)
    }
}

struct FeatureList: View {
    let features: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(features, id: \.self) { feature in
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(maincolor)
                    Text(feature)
                        .foregroundColor(textcolor)
                }
            }
        }
        .padding()
    }
}

struct AIIntroductionScreen_Previews: PreviewProvider {
    static var previews: some View {
        AIIntroductionScreen()
    }
}
