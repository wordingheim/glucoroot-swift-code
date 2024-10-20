import SwiftUI

struct Reminder: Identifiable {
    let id = UUID()
    var type: ReminderType
    var time: Date
    var description: String
    var isRecurring: Bool
    var recurringFrequency: RecurringFrequency?
}

enum ReminderType: String, CaseIterable, Identifiable {
    case medication = "Take Medication"
    case insulin = "Administer Insulin"
    case glucose = "Check Blood Glucose"
    case meal = "Eat a Meal"
    case snack = "Have a Snack"
    case exercise = "Exercise"
    case footCare = "Foot Care"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .medication: return "pill"
        case .insulin: return "cross.case"
        case .glucose: return "drop"
        case .meal: return "fork.knife"
        case .snack: return "cup.and.saucer"
        case .exercise: return "figure.walk"
        case .footCare: return "shoe"
        }
    }
}

enum RecurringFrequency: String, CaseIterable, Identifiable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    
    var id: String { self.rawValue }
}

struct RemindersView: View {
    @State private var reminders: [Reminder] = []
    @State private var newReminder = Reminder(type: .medication, time: Date(), description: "", isRecurring: false, recurringFrequency: nil)
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.9, green: 1.0, blue: 0.9) // Light green background
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        addReminderForm
                        
                        ForEach(reminders) { reminder in
                            ReminderCard(reminder: reminder, onDelete: deleteReminder)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Diabetes Reminders")
        }
    }
    
    var addReminderForm: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Add New Reminder")
                .font(.headline)
                .foregroundColor(.green)
            
            Picker("Type", selection: $newReminder.type) {
                ForEach(ReminderType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            DatePicker("Time", selection: $newReminder.time, displayedComponents: .hourAndMinute)
            
            TextField("Description", text: $newReminder.description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Toggle("Recurring Reminder", isOn: $newReminder.isRecurring)
            
            if newReminder.isRecurring {
                Picker("Frequency", selection: $newReminder.recurringFrequency.animation()) {
                    ForEach(RecurringFrequency.allCases) { frequency in
                        Text(frequency.rawValue).tag(frequency as RecurringFrequency?)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Button(action: addReminder) {
                Text("Add Reminder")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    func addReminder() {
        reminders.append(newReminder)
        newReminder = Reminder(type: .medication, time: Date(), description: "", isRecurring: false, recurringFrequency: nil)
    }
    
    func deleteReminder(_ reminder: Reminder) {
        reminders.removeAll { $0.id == reminder.id }
    }
}

struct ReminderCard: View {
    let reminder: Reminder
    let onDelete: (Reminder) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: reminder.type.icon)
                    .foregroundColor(.green)
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text(reminder.type.rawValue)
                        .font(.headline)
                    Text(reminder.time, style: .time)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: { onDelete(reminder) }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            
            if !reminder.description.isEmpty {
                Text(reminder.description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            if reminder.isRecurring, let frequency = reminder.recurringFrequency {
                Text("Repeats: \(frequency.rawValue)")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct RemindersView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersView()
    }
}
