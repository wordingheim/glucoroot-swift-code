//
//  BasicDiabetesQuestions.swift
//  DiabetesTest
//
//  Created by Ryan Lien on 10/19/24.
//
import SwiftUI

struct Question: Identifiable {
    let id = UUID()
    let key: String
    let text: String
    let options: [String]
}

struct BasicDiabetesQuestionsView: View {
    @State private var currentQuestionIndex = 0
    @State private var answers: [String: String] = [:]
    
    private let questions = [
        Question(key: "pairMeter",
                text: "Would you like to pair your GP meter?",
                options: ["Yes", "No"]),
        Question(key: "diabetesType",
                text: "What type of diabetes do you have?",
                options: ["Type 1", "Type 2", "Prediabetic", "Other"]),
        Question(key: "diagnosisTime",
                text: "When were you diagnosed with diabetes?",
                options: ["Less than 6 months ago", "Less than 1 year ago", "1-5 years ago", "Over 5 years ago"])
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Spacer(minLength: 20)
                    
                    questionCard
                        .padding(.horizontal)
                        .frame(maxWidth: 500)
                    
                    Spacer(minLength: 20)
                }
            }
            .navigationTitle("Basic Questions")
            .background(secondcolor.edgesIgnoringSafeArea(.all))
        }
    }
    
    var questionCard: some View {
        VStack(spacing: 25) {
            // Question Header
            VStack(spacing: 12) {
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(maincolor)
                    .padding(.bottom, 5)
                
                Text(questions[currentQuestionIndex].text)
                    .font(.title3)
                    .bold()
                    .foregroundColor(maincolor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.top, 10)
            
            // Options
            VStack(spacing: 15) {
                ForEach(questions[currentQuestionIndex].options, id: \.self) { option in
                    OptionButton(
                        title: option,
                        isSelected: answers[questions[currentQuestionIndex].key] == option,
                        action: {
                            answers[questions[currentQuestionIndex].key] = option
                            if currentQuestionIndex < questions.count - 1 {
                                withAnimation {
                                    currentQuestionIndex += 1
                                }
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 5)
            
            // Navigation Buttons
            HStack(spacing: 20) {
                if currentQuestionIndex > 0 {
                    Button(action: {
                        withAnimation {
                            currentQuestionIndex -= 1
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Previous")
                        }
                        .foregroundColor(maincolor)
                    }
                }
                
                Spacer()
                
                if currentQuestionIndex < questions.count - 1 {
                    Button(action: {
                        withAnimation {
                            currentQuestionIndex += 1
                        }
                    }) {
                        HStack {
                            Text("Next")
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(maincolor)
                    }
                }
            }
            .padding(.horizontal)
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

struct OptionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(isSelected ? maincolor : secondcolor)
                .foregroundColor(isSelected ? thirdcolor : textcolor)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(maincolor, lineWidth: 1)
                )
        }
    }
}

struct BasicDiabetesQuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        BasicDiabetesQuestionsView()
    }
}
