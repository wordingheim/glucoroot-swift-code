import SwiftUI

struct Meal: Identifiable {
    let id = UUID()
    var name: String
    var ingredients: [String]
    var time: String
    var notes: String
}

struct DayMealPlanner: View {
    @State private var meals: [String: Meal] = [:]
    @State private var groceryList: [String] = []
    @State private var newGroceryItem: String = ""
    
    let mealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Meal Planner")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.green.opacity(0.8))
                .padding(.top, 20)
            
            Text(Date().formatted(.dateTime.day().month().year()))
                .font(.title2)
                .fontWeight(.bold)
            
            // Meals Section
            VStack(spacing: 20) {
                ForEach(mealTypes, id: \.self) { type in
                    MealView(mealType: type, meal: $meals[type]) { newMeal in
                        meals[type] = newMeal
                    } removeMeal: {
                        meals.removeValue(forKey: type)
                    }
                }
            }
            .padding()
            .background(Color.green.opacity(0.2))
            .cornerRadius(10)
            
            // Grocery List Section
            VStack(spacing: 10) {
                Text("Grocery List")
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack {
                    TextField("Add item to grocery list", text: $newGroceryItem)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button(action: addGroceryItem) {
                        Image(systemName: "plus")
                    }
                }
                
                ForEach(groceryList.indices, id: \.self) { index in
                    HStack {
                        Text(groceryList[index])
                        Spacer()
                        Button(action: { removeGroceryItem(at: index) }) {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .padding()
            .background(Color.green.opacity(0.2))
            .cornerRadius(10)
            .padding(.bottom, 20)
        }
        .padding()
        .background(Color.green.opacity(0.1).ignoresSafeArea())
    }
    
    private func addGroceryItem() {
        if !newGroceryItem.trimmingCharacters(in: .whitespaces).isEmpty {
            groceryList.append(newGroceryItem.trimmingCharacters(in: .whitespaces))
            newGroceryItem = ""
        }
    }
    
    private func removeGroceryItem(at index: Int) {
        groceryList.remove(at: index)
    }
}

struct MealView: View {
    var mealType: String
    @Binding var meal: Meal?
    var updateMeal: (Meal) -> Void
    var removeMeal: () -> Void
    
    var body: some View {
        VStack {
            Text(mealType)
                .font(.headline)
                .padding(.bottom, 5)
            
            if let meal = meal {
                // Create a mutable copy of the meal
                var mutableMeal = meal
                
                TextField("Meal Name", text: Binding(
                    get: { mutableMeal.name },
                    set: { mutableMeal.name = $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: mutableMeal.name) { _ in updateMeal(mutableMeal) }
                
                TextField("Preparation Time", text: Binding(
                    get: { mutableMeal.time },
                    set: { mutableMeal.time = $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: mutableMeal.time) { _ in updateMeal(mutableMeal) }
                
                TextField("Ingredients (comma separated)", text: Binding(
                    get: { mutableMeal.ingredients.joined(separator: ", ") },
                    set: { mutableMeal.ingredients = $0.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) } }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: mutableMeal.ingredients) { _ in updateMeal(mutableMeal) }
                
                TextField("Notes", text: Binding(
                    get: { mutableMeal.notes },
                    set: { mutableMeal.notes = $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: mutableMeal.notes) { _ in updateMeal(mutableMeal) }
                
                HStack {
                    Button(action: {
                        // Save logic for the individual meal
                        print("Meal '\(mutableMeal.name)' saved!")
                    }) {
                        Text("Save Meal")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                    
                    Button(action: removeMeal) {
                        Text("Remove Meal")
                            .foregroundColor(.red)
                    }
                }
            } else {
                Button(action: {
                    let newMeal = Meal(name: "", ingredients: [], time: "", notes: "")
                    updateMeal(newMeal)
                }) {
                    Text("Add \(mealType)")
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct DayMealPlanner_Previews: PreviewProvider {
    static var previews: some View {
        DayMealPlanner()
    }
}
