//
//  ChatbotScreen.swift
//  DiabetesTest
//
//  Created by Ryan Lien on 10/19/24.
//

import SwiftUI

struct DiabetesAIAssistant: View {
    @State private var userName = "Sarah"
    @State private var isListening = false
    @State private var inputText = ""
    
    private let suggestionCards = [
        SuggestionCard(icon: "fork.knife", title: "Log Meal", description: "Record your food intake"),
        SuggestionCard(icon: "doc.text", title: "View Reports", description: "Check your health trends"),
        SuggestionCard(icon: "lightbulb", title: "Get Advice", description: "Personalized health tips"),
        SuggestionCard(icon: "apple", title: "Healthy Recipes", description: "Discover diabetes-friendly meals")
    ]
    
    private let navItems = [
        NavItem(icon: "house", label: "Home"),
        NavItem(icon: "apple", label: "Nutrition"),
        NavItem(icon: "person.3", label: "Community"),
        NavItem(icon: "person", label: "Profile")
    ]
    
    var body: some View {
        ZStack {
            Color(.systemGreen).opacity(0.1).edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("GlucoGuide")
                    .font(.system(size: 30, weight: .bold))
                Text("Your Personal Diabetes Assistant")
                    .font(.title)
                    .padding(.bottom)
                
                VStack(spacing: 20) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 64, height: 64)
                            .foregroundColor(.green)
                        Text("\(greeting), \(userName)!")
                            .font(.title2)
                    }
                    
                    Text("How can I assist you with your diabetes management today?")
                    
                    HStack {
                        Image(systemName: "message")
                            .foregroundColor(.green)
                        TextField("Ask GlucoGuide anything...", text: $inputText)
                        Button(action: {
                            isListening.toggle()
                        }) {
                            Image(systemName: "mic")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(isListening ? Color.red : Color.green)
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(25)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(suggestionCards, id: \.title) { card in
                        SuggestionCardView(card: card)
                    }
                }
                .padding()
                
                Spacer()
            }
            .padding()
            
            VStack {
                Spacer()
                HStack {
                    ForEach(navItems, id: \.label) { item in
                        NavItemView(item: item)
                    }
                }
                .padding()
                .background(Color.white)
                .shadow(radius: 5)
            }
        }
    }
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good morning"
        case 12..<18: return "Good afternoon"
        default: return "Good evening"
        }
    }
}

struct SuggestionCard: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

struct SuggestionCardView: View {
    let card: SuggestionCard
    
    var body: some View {
        HStack {
            Image(systemName: card.icon)
                .foregroundColor(.green)
                .padding()
                .background(Color.green.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(card.title)
                    .font(.headline)
                Text(card.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct NavItem: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
}

struct NavItemView: View {
    let item: NavItem
    
    var body: some View {
        VStack {
            Image(systemName: item.icon)
                .foregroundColor(.green)
            Text(item.label)
                .font(.caption)
        }
    }
}

struct DiabetesAIAssistant_Previews: PreviewProvider {
    static var previews: some View {
        DiabetesAIAssistant()
    }
}
