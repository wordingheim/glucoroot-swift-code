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
    @Environment(\.presentationMode) var presentationMode
    @State private var reminders: [Reminder] = []
    @State private var newReminder = Reminder(type: .medication, time: Date(), description: "", isRecurring: false, recurringFrequency: nil)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    addReminderForm
                    
                    ForEach(reminders) { reminder in
                        ReminderCard(reminder: reminder, onDelete: deleteReminder)
                    }
                }
                .padding()
            }
            .navigationTitle("Diabetes Reminders")
            .navigationBarItems(leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Dashboard")
                    }
                    .foregroundColor(maincolor)
                }
            )
            .background(secondcolor.opacity(0.6).edgesIgnoringSafeArea(.all))
        }
    }
    
    var addReminderForm: some View {
        VStack(alignment: .leading, spacing: 25) {
            Text("Add New Reminder")
                .font(.headline)
                .foregroundColor(maincolor)
            
            Picker("Type", selection: $newReminder.type) {
                ForEach(ReminderType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .accentColor(maincolor)
            
            // Updated DatePicker to include both date and time
            VStack(alignment: .leading) {
                Text("Date & Time")
                    .font(.subheadline)
                    .foregroundColor(maincolor)
                DatePicker("", selection: $newReminder.time)
                    .datePickerStyle(CompactDatePickerStyle())
                    .accentColor(maincolor)
                    .labelsHidden()
            }
            
            TextField("Description", text: $newReminder.description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(textcolor)
            
            Toggle("Recurring Reminder", isOn: $newReminder.isRecurring)
                .tint(maincolor)
            
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
                    .foregroundColor(maincolor)
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text(reminder.type.rawValue)
                        .font(.headline)
                        .foregroundColor(textcolor)
                    
                    // Updated to show both date and time
                    VStack(alignment: .leading, spacing: 2) {
                        Text(reminder.time, style: .date)
                            .font(.subheadline)
                            .foregroundColor(textcolor.opacity(0.7))
                        Text(reminder.time, style: .time)
                            .font(.subheadline)
                            .foregroundColor(textcolor.opacity(0.7))
                    }
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
                    .foregroundColor(textcolor.opacity(0.8))
            }
            
            if reminder.isRecurring, let frequency = reminder.recurringFrequency {
                Text("Repeats: \(frequency.rawValue)")
                    .font(.caption)
                    .foregroundColor(maincolor)
            }
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

struct RemindersView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersView()
    }
}
