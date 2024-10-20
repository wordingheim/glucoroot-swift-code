//
//  LoggingMedication.swift
//  DiabetesTest
//
//  Created by Ryan Lien on 10/19/24.
//
import SwiftUI

struct MedicationLoggingView: View {
    @State private var selectedMedication = "Select Medication"
    @State private var customMedication = ""
    @State private var units = ""
    @State private var timeOfDay = ""
    @State private var date = Date()
    @State private var sameAmountEveryTime = false
    @State private var notes = ""
    @State private var tags = ""

    let medications = [
        "Select Medication",
        "Insulin (Fast-Acting)",
        "Insulin (Long-Acting)",
        "Metformin",
        "Glipizide",
        "Sitagliptin",
        "Empagliflozin",
        "Other"
    ]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Medication Details").foregroundColor(.green)) {
                    Picker("Medication", selection: $selectedMedication) {
                        ForEach(medications, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    if selectedMedication == "Other" {
                        TextField("Enter custom medication", text: $customMedication)
                    }

                    TextField("Units", text: $units)

                    if selectedMedication.contains("Insulin") {
                        Picker("Time of Day", selection: $timeOfDay) {
                            Text("Select Time").tag("")
                            Text("Morning").tag("morning")
                            Text("Afternoon").tag("afternoon")
                            Text("Evening").tag("evening")
                            Text("Night").tag("night")
                        }
                        .pickerStyle(MenuPickerStyle())
                    }

                    DatePicker("Date and Time", selection: $date, displayedComponents: [.date, .hourAndMinute])

                    Toggle("Same amount every time?", isOn: $sameAmountEveryTime)

                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.green.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.vertical, 4)

                    TextField("Tags (comma-separated)", text: $tags)

                    Button(action: {
                        // Add photo logic here
                    }) {
                        HStack {
                            Image(systemName: "camera")
                            Text("Add Photo")
                        }
                    }
                    .foregroundColor(.green)
                }

                Section {
                    Button(action: {
                        // Handle form submission logic here
                        let medicationName = selectedMedication == "Other" ? customMedication : selectedMedication
                        print("Form submitted")
                        print("Medication: \(medicationName)")
                        print("Units: \(units)")
                        print("Time of Day: \(timeOfDay)")
                        print("Date: \(date)")
                        print("Same Amount: \(sameAmountEveryTime)")
                        print("Notes: \(notes)")
                        print("Tags: \(tags)")
                    }) {
                        Text("Log Medication")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationTitle("Log Medication")
        }
        .accentColor(.green)
    }
}

struct MedicationLoggingView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationLoggingView()
    }
}
