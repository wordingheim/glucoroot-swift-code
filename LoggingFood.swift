import SwiftUI

struct LoggedMeal: Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
    let carbs: Int
    let fats: Int
    let proteins: Int
    let portionSize: Int
    let servingUnit: String
    let notes: String
}

struct MealSection: View {
    let title: String
    @Binding var loggedMeals: [LoggedMeal]
    @Binding var favorites: [String]
    @State private var isExpanded = false
    @State private var showAddFood = false
    @State private var expandedMealId: UUID?

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: { isExpanded.toggle() }) {
                HStack {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
            }
            .padding(.vertical, 8)

            if isExpanded {
                ForEach(loggedMeals) { loggedMeal in
                    VStack {
                        HStack {
                            Text(loggedMeal.name)
                            Spacer()
                            Button(action: { expandedMealId = (expandedMealId == loggedMeal.id) ? nil : loggedMeal.id }) {
                                Image(systemName: "info.circle")
                            }
                            Button(action: { loggedMeals.removeAll { $0.id == loggedMeal.id } }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.vertical, 4)

                        if expandedMealId == loggedMeal.id {
                            VStack(alignment: .leading) {
                                Text("Calories: \(loggedMeal.calories)")
                                Text("Carbs: \(loggedMeal.carbs)g")
                                Text("Fats: \(loggedMeal.fats)g")
                                Text("Proteins: \(loggedMeal.proteins)g")
                                Text("Portion: \(loggedMeal.portionSize) \(loggedMeal.servingUnit)")
                                if !loggedMeal.notes.isEmpty {
                                    Text("Notes: \(loggedMeal.notes)")
                                }
                            }
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }

                Button(action: { showAddFood = true }) {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Add \(title)")
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
        .sheet(isPresented: $showAddFood) {
            AddFoodForm(onAddFood: { loggedMeal, isFavorite in
                loggedMeals.append(loggedMeal)
                if isFavorite && !favorites.contains(loggedMeal.name) {
                    favorites.append(loggedMeal.name)
                }
                showAddFood = false
            }, onCancel: { showAddFood = false })
        }
    }
}

struct AddFoodForm: View {
    @State private var foodName = ""
    @State private var calories = ""
    @State private var carbs = ""
    @State private var fats = ""
    @State private var proteins = ""
    @State private var portionSize = ""
    @State private var servingUnit = "grams"
    @State private var notes = ""
    @State private var isFavorite = false
    @Environment(\.presentationMode) var presentationMode

    let onAddFood: (LoggedMeal, Bool) -> Void
    let onCancel: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Food Details")) {
                    TextField("Food Name", text: $foodName)
                    TextField("Calories", text: $calories)
                        .keyboardType(.numberPad)
                    TextField("Carbs (g)", text: $carbs)
                        .keyboardType(.numberPad)
                    TextField("Fats (g)", text: $fats)
                        .keyboardType(.numberPad)
                    TextField("Proteins (g)", text: $proteins)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Portion")) {
                    TextField("Portion Size", text: $portionSize)
                        .keyboardType(.numberPad)
                    Picker("Serving Unit", selection: $servingUnit) {
                        ForEach(["grams", "cups", "ounces", "pieces"], id: \.self) { unit in
                            Text(unit).tag(unit)
                        }
                    }
                }

                Section(header: Text("Additional Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }

                Section {
                    Toggle("Add to Favorites", isOn: $isFavorite)
                }
            }
            .navigationTitle("Add Food")
            .navigationBarItems(
                leading: Button("Cancel") {
                    onCancel()
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Add") {
                    let loggedMeal = LoggedMeal(
                        name: foodName,
                        calories: Int(calories) ?? 0,
                        carbs: Int(carbs) ?? 0,
                        fats: Int(fats) ?? 0,
                        proteins: Int(proteins) ?? 0,
                        portionSize: Int(portionSize) ?? 0,
                        servingUnit: servingUnit,
                        notes: notes
                    )
                    onAddFood(loggedMeal, isFavorite)
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct FoodLoggingPage: View {
    @State private var loggedMeals: [String: [LoggedMeal]] = [
        "Breakfast": [],
        "Lunch": [],
        "Dinner": [],
        "Snack": []
    ]
    @State private var waterIntake = 0
    @State private var favorites: [String] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Daily Food Log")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)

                VStack {
                    Text("Water Intake")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    HStack {
                        Button(action: { waterIntake = max(0, waterIntake - 1) }) {
                            Image(systemName: "minus")
                        }
                        Text("\(waterIntake) glasses")
                            .font(.title3)
                        Button(action: { waterIntake += 1 }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 2)

                ForEach(["Breakfast", "Lunch", "Dinner", "Snack"], id: \.self) { mealType in
                    MealSection(
                        title: mealType,
                        loggedMeals: Binding(
                            get: { self.loggedMeals[mealType] ?? [] },
                            set: { self.loggedMeals[mealType] = $0 }
                        ),
                        favorites: $favorites
                    )
                }

                VStack(alignment: .leading) {
                    Text("Quick Access - Favorites")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(favorites, id: \.self) { favorite in
                                Text(favorite)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(20)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 2)
            }
            .padding()
        }
        .background(Color.green.opacity(0.1).edgesIgnoringSafeArea(.all))
    }
}

struct FoodLoggingPage_Previews: PreviewProvider {
    static var previews: some View {
        FoodLoggingPage()
    }
}
