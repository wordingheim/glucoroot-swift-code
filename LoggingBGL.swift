//
//  LoggingMedication.swift
//  DiabetesTest
//
//  Created by Ryan Lien on 10/19/24.
//

import SwiftUI

struct LogBloodGlucoseView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var glucoseLevel = ""
    @State private var unit = "mg/dL"
    @State private var tags = ""
    @State private var photo: UIImage?
    @State private var recordCurrentTime = true
    @State private var selectedDateTime = Date()
    @State private var mealStatus = ""
    @State private var notes = ""
    @State private var showingImagePicker = false
    @State private var showingDatePicker = false

    let units = ["mg/dL", "mmol/L"]
    let mealStatuses = ["Before Meal", "After Meal", "Fasting", "Bedtime"]

    // Custom colors
    private let backgroundGreen = Color(red: 240/255, green: 253/255, blue: 244/255) // Lighter green for background
    private let headerGreen = Color(red: 187/255, green: 247/255, blue: 208/255) // Slightly darker green for header
    private let buttonGreen = Color(red: 34/255, green: 197/255, blue: 94/255) // Darker green for buttons

    var body: some View {
        NavigationView {
            ZStack {
                backgroundGreen.edgesIgnoringSafeArea(.all) // Apply background color to entire view
                
                Form {
                    Section(header: Text("Blood Glucose").greenHeader()) {
                        HStack {
                            TextField("Glucose Level", text: $glucoseLevel)
                                .keyboardType(.numberPad)
                            Picker("Unit", selection: $unit) {
                                ForEach(units, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        if let level = Double(glucoseLevel), !glucoseLevel.isEmpty {
                            if isHighGlucose(level: level) {
                                AlertView(message: "High glucose level detected. Consider taking action.", type: .warning)
                            } else if isLowGlucose(level: level) {
                                AlertView(message: "Low glucose level detected. Please take immediate action.", type: .error)
                            }
                        }
                    }

                    Section(header: Text("Meal Status").greenHeader()) {
                        Picker("Meal Status", selection: $mealStatus) {
                            Text("Select").tag("")
                            ForEach(mealStatuses, id: \.self) {
                                Text($0)
                            }
                        }
                    }

                    Section(header: Text("Tags").greenHeader()) {
                        TextField("Tags (comma separated)", text: $tags)
                    }

                    Section(header: Text("Date and Time").greenHeader()) {
                        Toggle("Record current time", isOn: $recordCurrentTime)
                        if !recordCurrentTime {
                            Button("Select Date and Time") {
                                showingDatePicker = true
                            }
                        }
                    }

                    Section(header: Text("Notes").greenHeader()) {
                        TextEditor(text: $notes)
                            .frame(height: 100)
                    }

                    Section(header: Text("Photo").greenHeader()) {
                        if let photo = photo {
                            Image(uiImage: photo)
                                .resizable()
                                .scaledToFit()
                        }
                        Button("Add Photo") {
                            showingImagePicker = true
                        }
                    }

                    Button("Save") {
                        saveBloodGlucose()
                    }
                    .greenButton()
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .listStyle(GroupedListStyle())
            }
            .navigationTitle("Log Blood Glucose")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            )
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $photo)
            }
            .sheet(isPresented: $showingDatePicker) {
                DatePicker("Select Date and Time", selection: $selectedDateTime, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    .background(backgroundGreen)
            }
        }
        .accentColor(buttonGreen)
    }

    private func isHighGlucose(level: Double) -> Bool {
        return (unit == "mg/dL" && level > 180) || (unit == "mmol/L" && level > 10)
    }

    private func isLowGlucose(level: Double) -> Bool {
        return (unit == "mg/dL" && level < 70) || (unit == "mmol/L" && level < 3.9)
    }

    private func saveBloodGlucose() {
        // Implement saving logic here
        print("Saving: glucose level: \(glucoseLevel), unit: \(unit), tags: \(tags), meal status: \(mealStatus), notes: \(notes), date: \(selectedDateTime)")
    }
}

struct AlertView: View {
    let message: String
    let type: AlertType

    enum AlertType {
        case warning
        case error
    }

    var body: some View {
        HStack {
            Image(systemName: type == .warning ? "exclamationmark.triangle" : "exclamationmark.circle")
            Text(message)
        }
        .padding()
        .background(type == .warning ? Color.yellow.opacity(0.3) : Color.red.opacity(0.3))
        .cornerRadius(8)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// Custom modifiers to apply consistent styling
struct GreenButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(red: 34/255, green: 197/255, blue: 94/255))
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

struct GreenHeaderStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(red: 187/255, green: 247/255, blue: 208/255))
            .foregroundColor(Color(red: 21/255, green: 128/255, blue: 61/255)) // Dark green text for contrast
    }
}

extension View {
    func greenButton() -> some View {
        self.modifier(GreenButtonStyle())
    }
    
    func greenHeader() -> some View {
        self.modifier(GreenHeaderStyle())
    }
}

struct LogBloodGlucoseView_Previews: PreviewProvider {
    static var previews: some View {
        LogBloodGlucoseView()
    }
}
