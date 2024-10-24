import SwiftUI

struct DiabetesAIAssistant: View {
    @State private var userName = "Sarah"
    @State private var isListening = false
    @State private var inputText = ""
    
    var body: some View {
        ZStack {
            secondcolor.opacity(0.6).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Header Section
                headerSection
                
                // Assistant Section
                assistantSection
                    .padding()
                    .background(thirdcolor)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(bordercolor, lineWidth: 1)
                    )
                
                // Quick Actions Grid
                quickActionsGrid
                    .padding(.horizontal)
                
                Spacer()
                
                // Navigation Bar
                navigationBar
            }
            .padding(.top)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("GlucoGuide")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(maincolor)
            
            Text("Your Personal Diabetes Assistant")
                .font(.title3)
                .foregroundColor(textcolor)
        }
    }
    
    // MARK: - Assistant Section
    private var assistantSection: some View {
        VStack(spacing: 16) {
            // User Greeting
            HStack {
                // Replace the existing Image view with this:
                Image("AI_ChatbotAvatar1") // Use whatever name you gave the image in Assets
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(maincolor, lineWidth: 2)
                    )
                    .shadow(radius: 2)
                
                Text("\(greeting), \(userName)!")
                    .font(.title2)
                    .foregroundColor(textcolor)
                
                Spacer()
            }
            
            Text("How can I assist you today?")
                .foregroundColor(textcolor)
                .multilineTextAlignment(.center)
            
            // Input Field
            inputField
        }
        .padding()
    }
    
    // MARK: - Input Field
    private var inputField: some View {
        HStack(spacing: 12) {
            Image(systemName: "message")
                .foregroundColor(maincolor)
            
            TextField("Ask GlucoGuide anything...", text: $inputText)
                .foregroundColor(textcolor)
            
            Button(action: { isListening.toggle() }) {
                Image(systemName: "mic")
                    .foregroundColor(thirdcolor)
                    .padding(8)
                    .background(isListening ? Color.red : maincolor)
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(secondcolor.opacity(0.2))
        .cornerRadius(25)
    }
    
    // MARK: - Quick Actions Grid
    private var quickActionsGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ],
            spacing: 16
        ) {
            ForEach(suggestionCards) { card in
                SuggestionCardView(card: card)
            }
        }
    }
    
    // MARK: - Navigation Bar
    private var navigationBar: some View {
        HStack {
            ForEach(navItems) { item in
                Spacer()
                NavItemView(item: item)
                Spacer()
            }
        }
        .padding()
        .background(thirdcolor)
        .shadow(radius: 5)
        .overlay(
            Rectangle()
                .stroke(bordercolor, lineWidth: 1)
        )
    }
    
    // MARK: - Helper Properties
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        default: return "Good evening"
        }
    }
    
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
}

// MARK: - Supporting Views
struct SuggestionCard: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

struct SuggestionCardView: View {
    let card: SuggestionCard
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: card.icon)
                .foregroundColor(maincolor)
                .padding()
                .background(secondcolor.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(card.title)
                    .font(.headline)
                    .foregroundColor(textcolor)
                Text(card.description)
                    .font(.caption)
                    .foregroundColor(textcolor.opacity(0.6))
            }
            
            Spacer(minLength: 0)
        }
        .padding()
        .background(thirdcolor)
        .cornerRadius(10)
        .shadow(radius: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(bordercolor, lineWidth: 1)
        )
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
        VStack(spacing: 4) {
            Image(systemName: item.icon)
                .foregroundColor(maincolor)
            Text(item.label)
                .font(.caption)
                .foregroundColor(textcolor)
        }
    }
}

struct DiabetesAIAssistant_Previews: PreviewProvider {
    static var previews: some View {
        DiabetesAIAssistant()
    }
}
