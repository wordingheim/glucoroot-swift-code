import SwiftUI

struct BGLReading: Identifiable {
    let id = UUID()
    var glucoseLevel: String
    var units: GlucoseUnit
    var mealStatus: MealStatus
    var tags: Set<String>
    var timestamp: Date
    var notes: String
}

enum GlucoseUnit: String, CaseIterable, Identifiable {
    case mgdl = "mg/dL"
    case mmol = "mmol/L"
    
    var id: String { self.rawValue }
}

enum MealStatus: String, CaseIterable, Identifiable {
    case beforeMeal = "Before Meal"
    case afterMeal = "After Meal"
    case fasting = "Fasting"
    case bedtime = "Bedtime"
    case other = "Other"
    
    var id: String { self.rawValue }
}

enum BGLTag: String, CaseIterable, Identifiable {
    case exercise = "Exercise"
    case stress = "Stress"
    case illness = "Illness"
    case medication = "Medication"
    case alcohol = "Alcohol"
    case correction = "Correction"
    
    var id: String { self.rawValue }
}

struct LogBGLView: View {
    @State private var glucoseLevel: String = ""
    @State private var selectedUnit: GlucoseUnit = .mgdl
    @State private var selectedMealStatus: MealStatus = .beforeMeal
    @State private var selectedTags: Set<String> = []
    @State private var timestamp: Date = Date()
    @State private var notes: String = ""
    
    // Alert states
    @State private var showingAlert = false
    @State private var showingSuccessMessage = false
    @State private var validationTimer: Timer?
    
    var isGlucoseOutOfRange: Bool {
        guard let value = Double(glucoseLevel) else { return false }
        
        // Don't show warning for incomplete numbers
        if glucoseLevel.count < 1 {
            return false
        }
        
        switch selectedUnit {
        case .mgdl:
            // Only validate if the number seems complete (typically 2-3 digits for mg/dL)
            if glucoseLevel.count >= 2 {
                return value < 70 || value > 180
            }
            return false
        case .mmol:
            // Only validate if the number seems complete (typically includes decimal for mmol/L)
            if glucoseLevel.contains(".") || glucoseLevel.count >= 2 {
                return value < 3.9 || value > 10.0
            }
            return false
        }
    }
    
    var glucoseWarningMessage: String {
        guard let value = Double(glucoseLevel) else { return "" }
        
        let lowThreshold = selectedUnit == .mgdl ? 70.0 : 3.9
        let highThreshold = selectedUnit == .mgdl ? 180.0 : 10.0
        
        if value < lowThreshold {
            return "Low blood glucose detected. Consider consuming fast-acting carbohydrates and checking again in 15 minutes."
        } else if value > highThreshold {
            return "High blood glucose detected. Consider checking for ketones and following your treatment plan."
        }
        return ""
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Glucose Level Input Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Blood Glucose Level")
                            .font(.headline)
                            .foregroundColor(maincolor)
                        
                        HStack {
                            TextField("Enter glucose level", text: $glucoseLevel)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .foregroundColor(textcolor)
                                .onChange(of: glucoseLevel) { oldValue, newValue in
                                    // Cancel any existing timer
                                    validationTimer?.invalidate()
                                    
                                    // Set a new timer to validate after a short delay
                                    validationTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                                        showingAlert = isGlucoseOutOfRange
                                    }
                                }
                            
                            Picker("Units", selection: $selectedUnit) {
                                ForEach(GlucoseUnit.allCases) { unit in
                                    Text(unit.rawValue).tag(unit)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 120)
                        }
                        
                        if isGlucoseOutOfRange && !glucoseLevel.isEmpty {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                Text("Out of target range")
                                    .foregroundColor(.red)
                                    .font(.subheadline)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(thirdcolor)
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(bordercolor, lineWidth: 1))
                    
                    // Meal Status Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Meal Status")
                            .font(.headline)
                            .foregroundColor(maincolor)
                        
                        HStack {
                            Text(selectedMealStatus.rawValue)
                                .foregroundColor(textcolor)
                            Spacer()
                            Picker("", selection: $selectedMealStatus) {
                                ForEach(MealStatus.allCases) { status in
                                    Text(status.rawValue).tag(status)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .accentColor(maincolor)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(bordercolor, lineWidth: 1)
                        )
                    }
                    .padding()
                    .background(thirdcolor)
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(bordercolor, lineWidth: 1))
                    
                    // Tags Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Tags")
                            .font(.headline)
                            .foregroundColor(maincolor)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(BGLTag.allCases) { tag in
                                    BGLTagButton(
                                        tag: tag.rawValue,
                                        isSelected: selectedTags.contains(tag.rawValue)
                                    ) {
                                        if selectedTags.contains(tag.rawValue) {
                                            selectedTags.remove(tag.rawValue)
                                        } else {
                                            selectedTags.insert(tag.rawValue)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(thirdcolor)
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(bordercolor, lineWidth: 1))
                    
                    // Date & Time Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Date & Time")
                            .font(.headline)
                            .foregroundColor(maincolor)
                        
                        DatePicker("", selection: $timestamp)
                            .datePickerStyle(CompactDatePickerStyle())
                            .accentColor(maincolor)
                    }
                    .padding()
                    .background(thirdcolor)
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(bordercolor, lineWidth: 1))
                    
                    // Notes Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Notes")
                            .font(.headline)
                            .foregroundColor(maincolor)
                        
                        TextEditor(text: $notes)
                            .frame(height: 100)
                            .foregroundColor(textcolor)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(bordercolor, lineWidth: 1))
                    }
                    .padding()
                    .background(thirdcolor)
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(bordercolor, lineWidth: 1))
                    
                    // Save Button
                    Button(action: saveReading) {
                        Text("Save Reading")
                            .foregroundColor(thirdcolor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(maincolor)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("Log Blood Glucose")
            .background(secondcolor.opacity(0.6).edgesIgnoringSafeArea(.all))
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Blood Glucose Alert"),
                    message: Text(glucoseWarningMessage),
                    primaryButton: .default(Text("Log Anyway")) {
                        // Continue with logging
                    },
                    secondaryButton: .cancel()
                )
            }
            .overlay(
                // Success Message Popup
                ZStack {
                    if showingSuccessMessage {
                        VStack {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Blood Glucose Level Logged")
                                    .foregroundColor(.white)
                                    .font(.headline)
                            }
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                        }
                        .transition(.move(edge: .top))
                        .animation(.easeInOut, value: showingSuccessMessage)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showingSuccessMessage = false
                                }
                            }
                        }
                    }
                }
                .padding(.top, 20)
                , alignment: .top
            )
        }
    }
    
    func saveReading() {
        let reading = BGLReading(
            glucoseLevel: glucoseLevel,
            units: selectedUnit,
            mealStatus: selectedMealStatus,
            tags: selectedTags,
            timestamp: timestamp,
            notes: notes
        )
        // Save the reading to your data store
        
        // Show success message
        withAnimation {
            showingSuccessMessage = true
        }
        
        // Reset form
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            glucoseLevel = ""
            selectedTags.removeAll()
            notes = ""
            timestamp = Date()
        }
    }
}

struct BGLTagButton: View {
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
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(maincolor, lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct LogBGLView_Previews: PreviewProvider {
    static var previews: some View {
        LogBGLView()
    }
}
