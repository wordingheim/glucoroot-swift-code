import SwiftUI

struct Meal: Identifiable {
    let id = UUID()
    var name: String
    var prepTime: String
    var ingredients: [String]
    var notes: String
    var mealType: MealType
    var isExpanded: Bool = false
}

enum MealType: String {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snacks = "Snacks"
}

struct GroceryItem: Identifiable {
    let id = UUID()
    var name: String
    var isChecked: Bool = false
}

struct MealPlannerView: View {
    @State private var currentDate = Date()
    @State private var meals: [Meal] = []
    @State private var groceryList: [GroceryItem] = []
    @State private var expandedSection: MealType?
    @State private var addingNewMeal: Bool = false
    
    // New meal form states
    @State private var newMealName = ""
    @State private var newPrepTime = ""
    @State private var newIngredients = ""
    @State private var newNotes = ""
    
    // Grocery list states
    @State private var newGroceryItem = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Meal Planner")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(textcolor)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top)
                    
                    // Date Display
                    dateHeader
                    
                    // Meal Sections
                    mealSection(type: .breakfast)
                    mealSection(type: .lunch)
                    mealSection(type: .dinner)
                    mealSection(type: .snacks)
                    
                    // Grocery List
                    groceryListSection
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: backButton)
            .background(secondcolor.opacity(0.6).edgesIgnoringSafeArea(.all))
        }
    }
    
    var backButton: some View {
        Button(action: {
            // Handle back navigation
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back to Calendar")
            }
            .foregroundColor(maincolor)
        }
    }
    
    var dateHeader: some View {
        Text(currentDate.formatted(date: .long, time: .omitted))
            .font(.headline)
            .foregroundColor(textcolor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(thirdcolor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(bordercolor, lineWidth: 1)
            )
    }
    
    func mealSection(type: MealType) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header
            HStack {
                Text(type.rawValue)
                    .font(.title3)
                    .foregroundColor(textcolor)
                
                Spacer()
                
                if expandedSection != type {
                    Button(action: {
                        expandedSection = type
                        addingNewMeal = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(maincolor)
                    }
                }
            }
            
            // Expanded add meal form
            if expandedSection == type && addingNewMeal {
                addMealForm(type: type)
                    .transition(.opacity)
            }
            
            // Existing meals
            ForEach(meals.filter { $0.mealType == type }) { meal in
                MealCardView(meal: meal) { isExpanded in
                    if let index = meals.firstIndex(where: { $0.id == meal.id }) {
                        meals[index].isExpanded = isExpanded
                    }
                } onDelete: {
                    meals.removeAll { $0.id == meal.id }
                }
            }
        }
        .padding()
        .background(thirdcolor)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(bordercolor, lineWidth: 1)
        )
        .animation(.easeInOut, value: expandedSection)
    }
    
    func addMealForm(type: MealType) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Meal Name", text: $newMealName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Prep Time", text: $newPrepTime)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Ingredients (comma separated)", text: $newIngredients)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextEditor(text: $newNotes)
                .frame(height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(bordercolor, lineWidth: 1)
                )
            
            HStack {
                Button("Save") {
                    saveMeal(type: type)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(maincolor)
                .cornerRadius(8)
                
                Button("Cancel") {
                    cancelAddMeal()
                }
                .foregroundColor(.red)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(8)
    }
    
    func saveMeal(type: MealType) {
        let meal = Meal(
            name: newMealName,
            prepTime: newPrepTime,
            ingredients: newIngredients.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) },
            notes: newNotes,
            mealType: type
        )
        
        meals.append(meal)
        resetForm()
    }
    
    func cancelAddMeal() {
        resetForm()
    }
    
    func resetForm() {
        newMealName = ""
        newPrepTime = ""
        newIngredients = ""
        newNotes = ""
        expandedSection = nil
        addingNewMeal = false
    }
    
    var groceryListSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Grocery List")
                .font(.title3)
                .foregroundColor(textcolor)
            
            HStack {
                TextField("Add item", text: $newGroceryItem)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: addGroceryItem) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(maincolor)
                }
            }
            
            ForEach(groceryList) { item in
                HStack {
                    Button(action: { toggleGroceryItem(item) }) {
                        Image(systemName: item.isChecked ? "checkmark.square.fill" : "square")
                            .foregroundColor(maincolor)
                    }
                    
                    Text(item.name)
                        .strikethrough(item.isChecked)
                        .foregroundColor(textcolor)
                    
                    Spacer()
                    
                    Button(action: { removeGroceryItem(item) }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .padding()
        .background(thirdcolor)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(bordercolor, lineWidth: 1)
        )
    }
    
    func addGroceryItem() {
        guard !newGroceryItem.isEmpty else { return }
        groceryList.append(GroceryItem(name: newGroceryItem))
        newGroceryItem = ""
    }
    
    func toggleGroceryItem(_ item: GroceryItem) {
        if let index = groceryList.firstIndex(where: { $0.id == item.id }) {
            groceryList[index].isChecked.toggle()
        }
    }
    
    func removeGroceryItem(_ item: GroceryItem) {
        groceryList.removeAll { $0.id == item.id }
    }
}

struct MealCardView: View {
    let meal: Meal
    let onExpand: (Bool) -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: { onExpand(!meal.isExpanded) }) {
                HStack {
                    Text(meal.name)
                        .font(.headline)
                        .foregroundColor(textcolor)
                    
                    Spacer()
                    
                    Image(systemName: meal.isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(maincolor)
                    
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            
            if meal.isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Prep Time: \(meal.prepTime)")
                        .font(.subheadline)
                    
                    Text("Ingredients:")
                        .font(.subheadline)
                    ForEach(meal.ingredients, id: \.self) { ingredient in
                        Text("• \(ingredient)")
                            .font(.caption)
                    }
                    
                    if !meal.notes.isEmpty {
                        Text("Notes: \(meal.notes)")
                            .font(.caption)
                    }
                }
                .foregroundColor(textcolor)
                .padding(.leading)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(8)
        .animation(.easeInOut, value: meal.isExpanded)
    }
}

struct MealPlannerView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlannerView()
    }
}
