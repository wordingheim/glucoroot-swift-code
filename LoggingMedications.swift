import SwiftUI
import PhotosUI

struct MedicationLog: Identifiable {
    let id = UUID()
    var medicationName: String
    var units: String
    var amount: Double
    var date: Date
    var isSameAmount: Bool
    var notes: String
    var tags: [String]
    var photoData: Data?
}

struct MedicationOption: Identifiable {
    let id = UUID()
    var name: String
}

struct MedicationLoggingView: View {
    @State private var selectedMedication: String = "Select Medication"
    @State private var customMedication: String = ""
    @State private var selectedUnit: String = "Select Unit"
    @State private var amount: Double = 0
    @State private var date: Date = Date()
    @State private var isSameAmount: Bool = false
    @State private var notes: String = ""
    @State private var selectedTags: Set<String> = []
    @State private var showingCustomMedication: Bool = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    
    // Sample medications - in a real app, this would come from a database
    let medications = [
        MedicationOption(name: "Metformin"),
        MedicationOption(name: "Insulin"),
        MedicationOption(name: "Glipizide"),
        MedicationOption(name: "Other")
    ]
    
    // Common medication units
    let medicationUnits = [
        "mg (milligrams)",
        "g (grams)",
        "mcg (micrograms)",
        "mL (milliliters)",
        "L (liters)",
        "IU (international units)",
        "units",
        "tablets",
        "capsules",
        "drops",
        "patches",
        "puffs",
        "injections"
    ]
    
    let availableTags = ["Morning", "Afternoon", "Evening", "Before Meal", "After Meal"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    medicationLogForm
                }
                .padding()
            }
            .navigationTitle("Log Medication")
            .background(secondcolor.opacity(0.6).edgesIgnoringSafeArea(.all))
        }
    }
    
    var medicationLogForm: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Medication Selection
            Menu {
                ForEach(medications) { medication in
                    Button(action: {
                        selectedMedication = medication.name
                        showingCustomMedication = medication.name == "Other"
                    }) {
                        Text(medication.name)
                    }
                }
            } label: {
                HStack {
                    Text(selectedMedication)
                        .foregroundColor(textcolor)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(maincolor)
                }
                .padding()
                .background(thirdcolor)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(bordercolor, lineWidth: 1)
                )
            }
            
            // Custom Medication Input
            if showingCustomMedication {
                TextField("Enter medication name", text: $customMedication)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(textcolor)
            }
            
            // Amount and Units
            HStack {
                // Amount Field
                TextField("Amount", value: $amount, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .foregroundColor(textcolor)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
                
                // Units Menu
                Menu {
                    ForEach(medicationUnits, id: \.self) { unit in
                        Button(action: {
                            selectedUnit = unit
                        }) {
                            Text(unit)
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedUnit)
                            .foregroundColor(textcolor)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(maincolor)
                    }
                    .padding()
                    .background(thirdcolor)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(bordercolor, lineWidth: 1)
                    )
                }
            }
            
            // Date and Time
            DatePicker("Date & Time", selection: $date)
                .accentColor(maincolor)
                .foregroundColor(textcolor)
            
            // Same Amount Toggle
            Toggle("Same amount every time", isOn: $isSameAmount)
                .tint(maincolor)
                .foregroundColor(textcolor)
            
            // Notes
            Text("Notes")
                .foregroundColor(textcolor)
            TextEditor(text: $notes)
                .frame(height: 100)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(bordercolor, lineWidth: 1)
                )
            
            // Tags
            Text("Tags")
                .foregroundColor(textcolor)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(availableTags, id: \.self) { tag in
                        TagButton(tag: tag, isSelected: selectedTags.contains(tag)) {
                            if selectedTags.contains(tag) {
                                selectedTags.remove(tag)
                            } else {
                                selectedTags.insert(tag)
                            }
                        }
                    }
                }
            }
            
            // Photo Picker
            PhotosPicker(selection: $selectedPhotoItem,
                        matching: .images) {
                HStack {
                    Image(systemName: "camera")
                    Text("Add Photo")
                }
                .foregroundColor(maincolor)
                .padding()
                .background(thirdcolor)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(bordercolor, lineWidth: 1)
                )
            }
            
            if let photoData = selectedPhotoData,
               let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            }
            
            // Log Button
            Button(action: logMedication) {
                Text("Log Medication")
                    .foregroundColor(thirdcolor)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(maincolor)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(thirdcolor)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(bordercolor, lineWidth: 1)
        )
        .onChange(of: selectedPhotoItem) { _ in
            Task {
                if let data = try? await selectedPhotoItem?.loadTransferable(type: Data.self) {
                    selectedPhotoData = data
                }
            }
        }
    }
    
    func logMedication() {
        let medicationLog = MedicationLog(
            medicationName: showingCustomMedication ? customMedication : selectedMedication,
            units: selectedUnit,
            amount: amount,
            date: date,
            isSameAmount: isSameAmount,
            notes: notes,
            tags: Array(selectedTags),
            photoData: selectedPhotoData
        )
        // Here you would save the medication log to your data store
        // Reset form after logging
        resetForm()
    }
    
    func resetForm() {
        selectedMedication = "Select Medication"
        customMedication = ""
        selectedUnit = "Select Unit"
        amount = 0
        date = Date()
        isSameAmount = false
        notes = ""
        selectedTags.removeAll()
        selectedPhotoData = nil
        selectedPhotoItem = nil
        showingCustomMedication = false
    }
}

struct TagButton: View {
    let tag: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(tag)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? maincolor : thirdcolor)
                .foregroundColor(isSelected ? thirdcolor : textcolor)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(bordercolor, lineWidth: 1)
                )
        }
    }
}

struct MedicationLoggingView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationLoggingView()
    }
}
