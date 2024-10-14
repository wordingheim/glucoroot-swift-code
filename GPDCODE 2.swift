
import SwiftUI

struct Factor: Identifiable {
    let id = UUID()
    let name: String
    let impact: String
}

let factorList = [
    Factor(name: "Weight", impact: "Moderate"),
    Factor(name: "Blood Pressure", impact: "High"),
    Factor(name: "Family History", impact: "High"),
    Factor(name: "Physical Activity", impact: "Low"),
    Factor(name: "Diet", impact: "Moderate"),
    Factor(name: "Age", impact: "Moderate"),
    Factor(name: "Ethnicity", impact: "Low"),
    Factor(name: "Stress Level", impact: "Low")
]

struct FactorButton: View {
    let factor: Factor
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(factor.name)
                    .foregroundColor(.green)
                Spacer()
                Text(factor.impact)
                    .foregroundColor(impactColor)
                Image(systemName: "chevron.right")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.green, lineWidth: 1)
        )
    }
    
    private var impactColor: Color {
        switch factor.impact {
        case "High":
            return .red
        case "Moderate":
            return .yellow
        default:
            return .green
        }
    }
}

struct ResultsScreen: View {
    @State private var score: Int = 86
    @State private var showContent: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Your Diabetes Risk Assessment")
                    .font(.headline)
                    .foregroundColor(.green)
                
                HStack {
                    Text("\(score)")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(scoreColor)
                    Text("/ 100")
                        .font(.title)
                        .foregroundColor(.gray)
                }
                
                AlertView(title: "Risk Analysis", description: scoreDescription)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Risk Factors (Tap for details):")
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    ForEach(factorList) { factor in
                        FactorButton(factor: factor) {
                            print("Viewing details for: \(factor.name)")
                        }
                    }
                }
                
                Button(action: {
                    print("Accessing personalized dashboard")
                }) {
                    HStack {
                        Image(systemName: "rectangle.3.group")
                        Text("Access Your Personalized Dashboard")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            .padding()
        }
        .background(Color.green.opacity(0.1).edgesIgnoringSafeArea(.all))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    showContent = true
                }
            }
        }
    }
    
    private var scoreColor: Color {
        if score < 30 {
            return .green
        } else if score < 70 {
            return .yellow
        } else {
            return .red
        }
    }
    
    private var scoreDescription: String {
        let riskLevel = score > 70 ? "high" : score > 30 ? "moderate" : "low"
        return "Your diabetes risk score is \(score) out of 100, which is considered \(riskLevel). This assessment is based on various risk factors listed below. Tap on each factor for more detailed information and personalized recommendations."
    }
}

struct AlertView: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "exclamationmark.circle")
                Text(title)
                    .font(.headline)
            }
            Text(description)
                .font(.subheadline)
        }
        .padding()
        .background(Color.yellow.opacity(0.2))
        .cornerRadius(8)
    }
}

struct ContentView2: View {
    var body: some View {
        ResultsScreen()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
