import SwiftUI

struct NutritionPage: View {
    var body: some View {
        ZStack {
            Color(UIColor.systemGreen.withAlphaComponent(0.1)).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("Nutrition Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    /*LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        RecipeAICard()
                        MealPlannerCard()
                        NutritionTrackerCard()
                        FoodSuggestionsCard()
                    }*/
                    VStack {
                        RecipeAICard()
                        MealPlannerCard()
                        NutritionTrackerCard()
                        FoodSuggestionsCard()
                    }
                }
                .padding()
            }
        }
    }
}

struct RecipeAICard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "fork.knife")
                Text("Recipe AI")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.green)
            
            Text("Get personalized recipes based on your preferences and dietary needs")
                .foregroundColor(.gray)
            
            Button(action: {
                // Generate recipe action
            }) {
                Text("Generate Recipe")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(25)
            }
            
            Text("Popular ingredients:")
                .font(.caption)
                .foregroundColor(.gray)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(["Chicken", "Broccoli", "Quinoa", "Salmon", "Avocado"], id: \.self) { item in
                        Text(item)
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.green.opacity(0.1))
                            .foregroundColor(.green)
                            .cornerRadius(15)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct MealPlannerCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "book")
                Text("Meal Planner")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.green)
            
            Text("Plan your meals for better glucose management")
                .foregroundColor(.gray)
            
            Button(action: {
                // Create meal plan action
            }) {
                Text("Create Meal Plan")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(25)
            }
            
            HStack {
                VStack {
                    Text("Breakfast")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("Planned")
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
                Spacer()
                VStack {
                    Text("Lunch")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("Pending")
                        .fontWeight(.semibold)
                        .foregroundColor(.yellow)
                }
                Spacer()
                VStack {
                    Text("Dinner")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("Pending")
                        .fontWeight(.semibold)
                        .foregroundColor(.yellow)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct NutritionTrackerCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "chart.pie")
                Text("Nutrition Tracker")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.green)
            
            HStack {
                NutritionCircle(value: 75, max: 100, label: "Calories", color: .green)
                Spacer()
                NutritionCircle(value: 150, max: 200, label: "Carbs", color: .blue)
                Spacer()
                NutritionCircle(value: 75, max: 100, label: "Protein", color: .red)
                Spacer()
                NutritionCircle(value: 50, max: 65, label: "Fat", color: .yellow)
            }
            
            Button(action: {
                // Log food action
            }) {
                Text("Log Food")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(25)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct NutritionCircle: View {
    let value: Int
    let max: Int
    let label: String
    let color: Color
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 8.0)
                    .opacity(0.3)
                    .foregroundColor(color)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(Double(value) / Double(max), 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(color)
                    .rotationEffect(Angle(degrees: 270.0))
                
                Text("\(value)/\(max)")
                    .font(.caption)
                    .bold()
            }
            .frame(width: 60, height: 60)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct FoodSuggestionsCard: View {
    let foodItems = [
        ("Leafy Greens", "leaf"),
        ("Berries", "flame"),
        ("Whole Grains", "wheat"),
        ("Lean Proteins", "hare"),
        ("Nuts and Seeds", "nut"),
        ("Greek Yogurt", "cup.and.saucer")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "apple")
                Text("Food Suggestions")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.green)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(foodItems, id: \.0) { item in
                    HStack {
                        Image(systemName: item.1)
                        Text(item.0)
                            .font(.caption)
                            //.fontWeight(.medium)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}



struct NutritionPage_Previews: PreviewProvider {
    static var previews: some View {
        NutritionPage()
    }
}
