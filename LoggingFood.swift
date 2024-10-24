import SwiftUI

// MARK: - Models
struct FoodItem: Identifiable {
    let id = UUID()
    var name: String
    var calories: Double
    var carbs: Double
    var fat: Double
    var protein: Double
    var portionSize: Double
    var servingUnit: ServingUnit
    var notes: String
    var isFavorite: Bool
    var loggedMealType: LoggedMealType
}

enum ServingUnit: String, CaseIterable {
    case grams = "grams"
    case cups = "cups"
    case tablespoons = "tablespoons"
    case teaspoons = "teaspoons"
    case pieces = "pieces"
    case ounces = "ounces"
    case milliliters = "milliliters"
    case slices = "slices"
    case servings = "servings"
}

enum LoggedMealType: String, CaseIterable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snacks = "Snacks"
}

enum FoodEntryTab: String, CaseIterable {
    case basic = "Basic"
    case nutrition = "Nutrition"
    case notes = "Notes"
}

struct MealLoggingView: View {
    @State private var currentDate = Date()
    @State private var meals: [LoggedMealType: [FoodItem]] = [:]
    @State private var favorites: [LoggedMealType: [FoodItem]] = [:]
    @State private var expandedSection: LoggedMealType?
    @State private var selectedTab: FoodEntryTab = .basic
    
    @State private var newFoodItem = FoodItem(
        name: "",
        calories: 0,
        carbs: 0,
        fat: 0,
        protein: 0,
        portionSize: 1,
        servingUnit: .servings,
        notes: "",
        isFavorite: false,
        loggedMealType: .breakfast
    )
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Meal Logger")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(textcolor)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top)
                    
                    dateHeader
                    
                    ForEach(LoggedMealType.allCases, id: \.self) { mealType in
                        VStack(spacing: 0) {
                            mealSection(type: mealType)
                            
                            if expandedSection == mealType {
                                foodEntryForm(for: mealType)
                                    .transition(.move(edge: .top))
                            }
                        }
                    }
                    
                    favoritesSection
                }
                .padding()
            }
            .navigationBarItems(
                leading: Button(action: {
                    // Handle back navigation
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back to Meal Log Calendar")
                    }
                    .foregroundColor(maincolor)
                }
            )
            .background(secondcolor.opacity(0.6).edgesIgnoringSafeArea(.all))
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
    
    func mealSection(type: LoggedMealType) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(type.rawValue)
                    .font(.title3)
                    .foregroundColor(textcolor)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        if expandedSection == type {
                            expandedSection = nil
                        } else {
                            expandedSection = type
                            newFoodItem.loggedMealType = type
                            selectedTab = .basic
                            resetNewFoodItem()
                        }
                    }
                }) {
                    Image(systemName: expandedSection == type ? "minus.circle.fill" : "plus.circle.fill")
                        .foregroundColor(maincolor)
                }
            }
            
            ForEach(meals[type] ?? []) { food in
                FoodItemCard(food: food) {
                    deleteFoodItem(food, from: type)
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
    
    func foodEntryForm(for mealType: LoggedMealType) -> some View {
        VStack(spacing: 15) {
            Picker("Entry Section", selection: $selectedTab) {
                ForEach(FoodEntryTab.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .colorMultiply(maincolor)
            
            switch selectedTab {
            case .basic:
                basicInfoTab
            case .nutrition:
                nutritionInfoTab
            case .notes:
                notesTab
            }
            
            HStack {
                Button("Cancel") {
                    withAnimation {
                        expandedSection = nil
                        resetNewFoodItem()
                    }
                }
                .foregroundColor(.red)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
                
                Spacer()
                
                Button("Save") {
                    saveFoodItem()
                    withAnimation {
                        expandedSection = nil
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(maincolor)
                .cornerRadius(8)
            }
            .padding(.top)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
    }
    
    var basicInfoTab: some View {
        VStack(spacing: 15) {
            TextField("Food Name", text: $newFoodItem.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(textcolor)
            
            HStack {
                TextField("Portion Size", value: $newFoodItem.portionSize, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .foregroundColor(textcolor)
                
                Picker("Unit", selection: $newFoodItem.servingUnit) {
                    ForEach(ServingUnit.allCases, id: \.self) { unit in
                        Text(unit.rawValue).tag(unit)
                    }
                }
                .foregroundColor(textcolor)
            }
            
            Toggle("Add to Favorites", isOn: $newFoodItem.isFavorite)
                .foregroundColor(textcolor)
        }
    }
    
    var nutritionInfoTab: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Calories")
                    .foregroundColor(textcolor)
                TextField("", value: $newFoodItem.calories, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .foregroundColor(textcolor)
            }
            
            HStack {
                Text("Carbs (g)")
                    .foregroundColor(textcolor)
                TextField("", value: $newFoodItem.carbs, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .foregroundColor(textcolor)
            }
            
            HStack {
                Text("Fat (g)")
                    .foregroundColor(textcolor)
                TextField("", value: $newFoodItem.fat, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .foregroundColor(textcolor)
            }
            
            HStack {
                Text("Protein (g)")
                    .foregroundColor(textcolor)
                TextField("", value: $newFoodItem.protein, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .foregroundColor(textcolor)
            }
        }
    }
    
    var notesTab: some View {
        TextEditor(text: $newFoodItem.notes)
            .frame(height: 100)
            .foregroundColor(textcolor)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(bordercolor, lineWidth: 1)
            )
    }
    
    var favoritesSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Favorites")
                .font(.title3)
                .foregroundColor(textcolor)
            
            ForEach(LoggedMealType.allCases, id: \.self) { mealType in
                if let favoritesForType = favorites[mealType], !favoritesForType.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(mealType.rawValue)
                            .font(.headline)
                            .foregroundColor(textcolor)
                        
                        ForEach(favoritesForType) { food in
                            FavoriteItemCard(food: food) {
                                addFavoriteToMeal(food)
                            }
                        }
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
    
    func saveFoodItem() {
        var currentMeals = meals[newFoodItem.loggedMealType] ?? []
        currentMeals.append(newFoodItem)
        meals[newFoodItem.loggedMealType] = currentMeals
        
        if newFoodItem.isFavorite {
            var currentFavorites = favorites[newFoodItem.loggedMealType] ?? []
            currentFavorites.append(newFoodItem)
            favorites[newFoodItem.loggedMealType] = currentFavorites
        }
        
        resetNewFoodItem()
    }
    
    func resetNewFoodItem() {
        newFoodItem = FoodItem(
            name: "",
            calories: 0,
            carbs: 0,
            fat: 0,
            protein: 0,
            portionSize: 1,
            servingUnit: .servings,
            notes: "",
            isFavorite: false,
            loggedMealType: newFoodItem.loggedMealType
        )
    }
    
    func deleteFoodItem(_ food: FoodItem, from mealType: LoggedMealType) {
        meals[mealType]?.removeAll { $0.id == food.id }
    }
    
    func addFavoriteToMeal(_ food: FoodItem) {
        var foodCopy = food
        foodCopy.loggedMealType = expandedSection ?? food.loggedMealType
        saveFoodItem()
    }
}

struct FoodItemCard: View {
    let food: FoodItem
    let onDelete: () -> Void
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: { isExpanded.toggle() }) {
                HStack {
                    Text(food.name)
                        .font(.headline)
                        .foregroundColor(textcolor)
                    
                    Spacer()
                    
                    if food.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Portion: \(food.portionSize, specifier: "%.1f") \(food.servingUnit.rawValue)")
                    Text("Calories: \(food.calories, specifier: "%.0f")")
                    Text("Carbs: \(food.carbs, specifier: "%.1f")g")
                    Text("Fat: \(food.fat, specifier: "%.1f")g")
                    Text("Protein: \(food.protein, specifier: "%.1f")g")
                    
                    if !food.notes.isEmpty {
                        Text("Notes: \(food.notes)")
                    }
                }
                .foregroundColor(textcolor)
                .padding(.leading)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(8)
        .animation(.easeInOut, value: isExpanded)
    }
}

struct FavoriteItemCard: View {
    let food: FoodItem
    let onAdd: () -> Void
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: { isExpanded.toggle() }) {
                HStack {
                    Text(food.name)
                        .font(.headline)
                        .foregroundColor(textcolor)
                    
                    Spacer()
                    
                    Button(action: onAdd) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(maincolor)
                    }
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Portion: \(food.portionSize, specifier: "%.1f") \(food.servingUnit.rawValue)")
                    Text("Calories: \(food.calories, specifier: "%.0f")")
                    Text("Carbs: \(food.carbs, specifier: "%.1f")g")
                    Text("Fat: \(food.fat, specifier: "%.1f")g")
                    Text("Protein: \(food.protein, specifier: "%.1f")g")
                    
                    if !food.notes.isEmpty {
                        Text("Notes: \(food.notes)")
                    }
                }
                .padding(.leading)
            }
        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(8)
        .animation(.easeInOut, value: isExpanded)
    }
}

struct MealLoggingView_Previews: PreviewProvider {
    static var previews: some View {
        MealLoggingView()
    }
}
