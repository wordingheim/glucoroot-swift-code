//
//  Resultspage.swift
//  ML Test
//
//  Created by Minseo Kim on 10/15/24.
//
import SwiftUI

struct DiabetesRiskResult: View {
    let riskPercentage: Double
    @State private var showDashboardButton = false
    
    private var riskLevel: String {
        if riskPercentage < 20 {
            return "Low"
        } else if riskPercentage < 50 {
            return "Moderate"
        } else {
            return "High"
        }
    }
    
    private var progressColor: Color {
        if riskPercentage < 20 {
            return .green
        } else if riskPercentage < 50 {
            return .yellow
        } else {
            return .red
        }
    }
    
    var body: some View {
        ZStack {
            Color(secondcolor).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("Your Diabetes Risk Assessment")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    VStack(spacing: 10) {
                        HStack {
                            Text("Your Risk:")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(Int(riskPercentage))%")
                                .font(.system(size: 40))
                                .fontWeight(.bold)
                                .foregroundColor(progressColor)
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 24)
                                
                                Rectangle()
                                    .fill(progressColor)
                                    .frame(width: CGFloat(riskPercentage) / 100 * geometry.size.width, height: 24)
                            }
                            .cornerRadius(12)
                        }
                        .frame(height: 24)
                        
                        HStack {
                            Text("Low Risk")
                            Spacer()
                            Text("Moderate Risk")
                            Spacer()
                            Text("High Risk")
                        }
                        .font(.caption)
                        .foregroundColor(.gray)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Risk Level:")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(riskLevel)
                                .fontWeight(.bold)
                                .foregroundColor(progressColor)
                        }
                        
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: riskLevel == "Low" ? "hand.thumbsup.fill" : "exclamationmark.triangle.fill")
                                .foregroundColor(progressColor)
                            
                            Text(riskLevelDescription)
                                .foregroundColor(progressColor)
                        }
                    }
                    
                    // Button for viewing detailed report
                    Button(action: {
                        // Action for viewing detailed report
                        showDashboardButton = false // Just for clarity, resetting state
                    }) {
                        HStack {
                            Text("View Detailed Report")
                            Image(systemName: "arrow.right")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(maincolor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    
                    // Button for direct dashboard access
                    Button(action: {
                        showDashboardButton = true
                    }) {
                        Text("See your personalized dashboard")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(maincolor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                    // Button for retaking assessment
                    Button(action: {
                        // Action for retaking assessment
                    }) {
                        Text("Retake Assessment")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(maincolor)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(maincolor, lineWidth: 1)
                            )
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(0)
                .shadow(radius: 10)
                .padding()
            }
        }
    }
    
    private var riskLevelDescription: String {
        switch riskLevel {
        case "High":
            return "Your risk is higher than average. We recommend consulting with a healthcare professional."
        case "Moderate":
            return "Your risk is moderate. Consider discussing your results with a healthcare provider."
        default:
            return "Your risk is low. Keep up the good work with your health!"
        }
    }
}

struct DiabetesRiskResult_Previews: PreviewProvider {
    static var previews: some View {
        DiabetesRiskResult(riskPercentage: 88)
    }
}
