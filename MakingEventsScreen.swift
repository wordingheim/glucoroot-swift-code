//
//  Community_EventsView.swift
//  DiabetesTest
//
//  Created by Ryan Lien on 10/24/24.
//

import SwiftUI
import PhotosUI
import MapKit

struct DiabetesEvent: Identifiable {
    let id = UUID()
    var title: String
    var eventType: EventType
    var startDate: Date
    var endDate: Date
    var isVirtual: Bool
    var location: String
    var virtualLink: String?
    var description: String
    var organizer: String
    var maxParticipants: Int?
    var currentParticipants: Int
    var foodServed: Bool
    var carbInformation: String?
    var medicalProfessionals: [String]
    var diabetesTypes: Set<DiabetesType>
    var tags: Set<String>
    var photoData: Data?
}

enum EventType: String, CaseIterable, Identifiable {
    case support = "Support Group"
    case education = "Educational Session"
    case social = "Social Gathering"
    case exercise = "Workout Session"
    case medical = "Medical Workshop"
    case other = "Other"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .support: return "heart.circle"
        case .education: return "book.circle"
        case .social: return "person.3"
        case .exercise: return "figure.walk"
        case .medical: return "cross.circle"
        case .other: return "circle"
        }
    }
}

enum DiabetesType: String, CaseIterable, Identifiable {
    case type1 = "Type 1"
    case type2 = "Type 2"
    case gestational = "Gestational"
    case prediabetes = "Prediabetes"
    case all = "All Types"
    
    var id: String { self.rawValue }
}

struct EventCreationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var selectedEventType: EventType = .support
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(3600)
    @State private var isVirtual: Bool = false
    @State private var location: String = ""
    @State private var virtualLink: String = ""
    @State private var description: String = ""
    @State private var organizer: String = ""
    @State private var hasMaxParticipants: Bool = false
    @State private var maxParticipants: Int = 10
    @State private var foodServed: Bool = false
    @State private var carbInformation: String = ""
    @State private var medicalProfessionals: [String] = []
    @State private var newProfessional: String = ""
    @State private var selectedDiabetesTypes: Set<DiabetesType> = []
    @State private var selectedTags: Set<String> = []
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    
    let availableTags = ["Beginners Welcome", "Free Event", "Family Friendly",
                        "Bilingual", "Teens", "Adults", "Seniors", "Parents"]
    
    var body: some View {
           NavigationView {
               ScrollView {
                   VStack(spacing: 20) {
                       eventCreationForm
                   }
                   .padding()
               }
               .navigationTitle("Create Event")
               .navigationBarItems(leading:
                   Button(action: {
                       presentationMode.wrappedValue.dismiss()
                   }) {
                       HStack {
                           Image(systemName: "chevron.left")
                           Text("Back to Community")
                       }
                       .foregroundColor(maincolor)
                   }
               )
               .background(secondcolor.opacity(0.6).edgesIgnoringSafeArea(.all))
           }
       }
    
    var eventCreationForm: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Basic Information Section
            GroupBox(label: Text("Basic Information").foregroundColor(textcolor)) {
                VStack(alignment: .leading, spacing: 12) {
                    TextField("Event Title", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // Event Type Picker
                    Menu {
                        ForEach(EventType.allCases) { type in
                            Button(action: { selectedEventType = type }) {
                                HStack {
                                    Image(systemName: type.icon)
                                    Text(type.rawValue)
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: selectedEventType.icon)
                            Text(selectedEventType.rawValue)
                                .foregroundColor(textcolor)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(maincolor)
                        }
                        .padding()
                        .background(thirdcolor)
                        .cornerRadius(10)
                    }
                    
                    // Date and Time
                    DatePicker("Start", selection: $startDate)
                    DatePicker("End", selection: $endDate)
                }
            }
            .groupBoxStyle(CardGroupBoxStyle())
            
            // Location Section
            GroupBox(label: Text("Location Details").foregroundColor(textcolor)) {
                VStack(alignment: .leading, spacing: 12) {
                    Toggle("Virtual Event", isOn: $isVirtual)
                        .tint(maincolor)
                    
                    if isVirtual {
                        TextField("Virtual Meeting Link", text: $virtualLink)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        TextField("Physical Location", text: $location)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
            }
            .groupBoxStyle(CardGroupBoxStyle())
            
            // Event Details Section
            GroupBox(label: Text("Event Details").foregroundColor(textcolor)) {
                VStack(alignment: .leading, spacing: 12) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(bordercolor, lineWidth: 1))
                    
                    TextField("Organizer/Host", text: $organizer)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Toggle("Limit Participants", isOn: $hasMaxParticipants)
                        .tint(maincolor)
                    
                    if hasMaxParticipants {
                        Stepper("Max Participants: \(maxParticipants)", value: $maxParticipants, in: 1...1000)
                    }
                }
            }
            .groupBoxStyle(CardGroupBoxStyle())
            
            // Diabetes-Specific Information
            GroupBox(label: Text("Diabetes Information").foregroundColor(textcolor)) {
                VStack(alignment: .leading, spacing: 15) {
                    // Diabetes Types
                    Text("Target Audience")
                        .foregroundColor(textcolor)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(DiabetesType.allCases) { type in
                                TagButton(tag: type.rawValue,
                                        isSelected: selectedDiabetesTypes.contains(type)) {
                                    if selectedDiabetesTypes.contains(type) {
                                        selectedDiabetesTypes.remove(type)
                                    } else {
                                        selectedDiabetesTypes.insert(type)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Food Information
                    Toggle("Food Will Be Served", isOn: $foodServed)
                        .tint(maincolor)
                    
                    if foodServed {
                        TextField("Carb Information", text: $carbInformation)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // Medical Professionals
                    Text("Medical Professionals Present")
                        .foregroundColor(textcolor)
                    HStack {
                        TextField("Add Medical Professional", text: $newProfessional)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: {
                            if !newProfessional.isEmpty {
                                medicalProfessionals.append(newProfessional)
                                newProfessional = ""
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(maincolor)
                        }
                    }
                    
                    ForEach(medicalProfessionals, id: \.self) { professional in
                        HStack {
                            Text(professional)
                            Spacer()
                            Button(action: {
                                medicalProfessionals.removeAll { $0 == professional }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            .groupBoxStyle(CardGroupBoxStyle())
            
            // Tags Section
            GroupBox(label: Text("Tags").foregroundColor(textcolor)) {
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
            }
            .groupBoxStyle(CardGroupBoxStyle())
            
            // Photo Section
            GroupBox(label: Text("Event Photo").foregroundColor(textcolor)) {
                VStack {
                    PhotosPicker(selection: $selectedPhotoItem,
                                matching: .images) {
                        HStack {
                            Image(systemName: "camera")
                            Text("Add Event Photo")
                        }
                        .foregroundColor(maincolor)
                        .padding()
                        .background(thirdcolor)
                        .cornerRadius(10)
                    }
                    
                    if let photoData = selectedPhotoData,
                       let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                    }
                }
            }
            .groupBoxStyle(CardGroupBoxStyle())
            
            // Create Event Button
            Button(action: createEvent) {
                Text("Create Event")
                    .foregroundColor(thirdcolor)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(maincolor)
                    .cornerRadius(10)
            }
            .disabled(title.isEmpty || (isVirtual ? virtualLink.isEmpty : location.isEmpty))
        }
        .onChange(of: selectedPhotoItem) { _ in
            Task {
                if let data = try? await selectedPhotoItem?.loadTransferable(type: Data.self) {
                    selectedPhotoData = data
                }
            }
        }
    }
    
    func createEvent() {
        let event = DiabetesEvent(
            title: title,
            eventType: selectedEventType,
            startDate: startDate,
            endDate: endDate,
            isVirtual: isVirtual,
            location: isVirtual ? virtualLink : location,
            virtualLink: isVirtual ? virtualLink : nil,
            description: description,
            organizer: organizer,
            maxParticipants: hasMaxParticipants ? maxParticipants : nil,
            currentParticipants: 0,
            foodServed: foodServed,
            carbInformation: foodServed ? carbInformation : nil,
            medicalProfessionals: medicalProfessionals,
            diabetesTypes: selectedDiabetesTypes,
            tags: selectedTags,
            photoData: selectedPhotoData
        )
        // Here you would save the event to your data store
        resetForm()
    }
    
    func resetForm() {
        title = ""
        selectedEventType = .support
        startDate = Date()
        endDate = Date().addingTimeInterval(3600)
        isVirtual = false
        location = ""
        virtualLink = ""
        description = ""
        organizer = ""
        hasMaxParticipants = false
        maxParticipants = 10
        foodServed = false
        carbInformation = ""
        medicalProfessionals.removeAll()
        selectedDiabetesTypes.removeAll()
        selectedTags.removeAll()
        selectedPhotoData = nil
        selectedPhotoItem = nil
    }
}

struct CardGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.label
            configuration.content
        }
        .padding()
        .background(thirdcolor)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(bordercolor, lineWidth: 1)
        )
    }
}

struct EventCreationView_Previews: PreviewProvider {
    static var previews: some View {
        EventCreationView()
    }
}
