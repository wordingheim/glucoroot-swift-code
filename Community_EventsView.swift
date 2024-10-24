import SwiftUI
import EventKit

struct ScheduledEvent: Identifiable {
    let id: Int
    let title: String
    let type: ScheduledEventType
    let description: String
    let date: Date
    let endDate: Date
    let location: String
    let isVirtual: Bool
    let host: String
    let attendeeCount: Int
    let maxAttendees: Int?
    let cost: Double?
    var isRegistered: Bool = false
}

enum ScheduledEventType: String, CaseIterable, Identifiable {
    case supportGroup = "Support Group"
    case workshop = "Workshop"
    case exercise = "Exercise Class"
    case cooking = "Cooking Demo"
    case social = "Social Meetup"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .supportGroup: return "person.3"
        case .workshop: return "book"
        case .exercise: return "figure.walk"
        case .cooking: return "fork.knife"
        case .social: return "cup.and.saucer"
        }
    }
}

struct EventsView: View {
    @State private var activeTab = "events"
    @State private var showRegistrationAlert = false
    @State private var registeredEventName = ""
    @State private var selectedFilter: ScheduledEventType? = nil
    @State private var showDatePicker = false
    @State private var selectedDate = Date()
    
    @State private var myEvents: [ScheduledEvent] = [
        ScheduledEvent(id: 1,
              title: "Weekly T1D Check-in",
              type: .supportGroup,
              description: "Join our weekly support group meeting to share experiences and tips.",
              date: Date().addingTimeInterval(86400),
              endDate: Date().addingTimeInterval(90000),
              location: "Zoom",
              isVirtual: true,
              host: "Sarah Johnson",
              attendeeCount: 15,
              maxAttendees: 20,
              cost: nil,
              isRegistered: true),
        ScheduledEvent(id: 2,
              title: "Diabetes-Friendly Cooking",
              type: .cooking,
              description: "Learn to prepare low-carb meals that don't compromise on taste.",
              date: Date().addingTimeInterval(172800),
              endDate: Date().addingTimeInterval(180000),
              location: "Community Center",
              isVirtual: false,
              host: "Chef Mike Brown",
              attendeeCount: 12,
              maxAttendees: 15,
              cost: 25.0,
              isRegistered: true)
    ]
    
    @State private var upcomingEvents: [ScheduledEvent] = [
        ScheduledEvent(id: 3,
              title: "Morning Yoga for Diabetics",
              type: .exercise,
              description: "Gentle yoga session suitable for all fitness levels.",
              date: Date().addingTimeInterval(259200),
              endDate: Date().addingTimeInterval(266400),
              location: "City Park",
              isVirtual: false,
              host: "Lisa Chen",
              attendeeCount: 8,
              maxAttendees: 20,
              cost: 15.0),
        ScheduledEvent(id: 4,
              title: "New Technology Workshop",
              type: .workshop,
              description: "Learn about the latest diabetes management technologies.",
              date: Date().addingTimeInterval(432000),
              endDate: Date().addingTimeInterval(439200),
              location: "Zoom",
              isVirtual: true,
              host: "Dr. James Wilson",
              attendeeCount: 45,
              maxAttendees: 100,
              cost: nil)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    ZStack {
                        secondcolor
                        VStack {
                            Spacer()
                                .frame(height: 120)
                            Text("GlucoRoot Events")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    .frame(height: 60)
                    .ignoresSafeArea(edges: .top)
                    
                    // Filters
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            FilterButton(title: "All", isSelected: selectedFilter == nil) {
                                selectedFilter = nil
                            }
                            
                            ForEach(ScheduledEventType.allCases) { type in
                                FilterButton(title: type.rawValue, isSelected: selectedFilter == type) {
                                    selectedFilter = type
                                }
                            }
                        }
                        .padding()
                    }
                    .background(Color.white)
                    
                    // Content
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            // My Events Section
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("My Events")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        showDatePicker.toggle()
                                    }) {
                                        Image(systemName: "calendar")
                                            .foregroundColor(maincolor)
                                    }
                                }
                                .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(filteredMyEvents) { event in
                                            MyEventCard(event: event)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.top, 16)
                            
                            // Divider
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 8)
                                .padding(.vertical, 8)
                            
                            // Upcoming Events Section
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Discover Events")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    Menu {
                                        Button("Date: Newest", action: {})
                                        Button("Date: Oldest", action: {})
                                        Button("Most Popular", action: {})
                                    } label: {
                                        Image(systemName: "slider.horizontal.3")
                                            .foregroundColor(maincolor)
                                    }
                                }
                                .padding(.horizontal)
                                
                                LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                                    ForEach(filteredUpcomingEvents) { event in
                                        UpcomingEventCard(event: event,
                                                        showRegistrationAlert: $showRegistrationAlert,
                                                        registeredEventName: $registeredEventName)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                    .overlay(
                        VStack {
                            Spacer()
                            CreateEventButton()
                                .padding(20)
                        }
                    )
                }
            }
            .sheet(isPresented: $showDatePicker) {
                DatePickerView(selectedDate: $selectedDate, isPresented: $showDatePicker)
            }
            .alert("Registration Successful!", isPresented: $showRegistrationAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("You have registered for \(registeredEventName)")
            }
        }
    }
    
    var filteredMyEvents: [ScheduledEvent] {
        let filtered = myEvents.filter { event in
            if let filter = selectedFilter {
                return event.type == filter
            }
            return true
        }
        return filtered.sorted { $0.date < $1.date }
    }
    
    var filteredUpcomingEvents: [ScheduledEvent] {
        let filtered = upcomingEvents.filter { event in
            if let filter = selectedFilter {
                return event.type == filter
            }
            return true
        }
        return filtered.sorted { $0.date < $1.date }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? maincolor : Color.clear)
                .foregroundColor(isSelected ? .white : .gray)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? maincolor : Color.gray, lineWidth: 1)
                )
        }
    }
}

struct MyEventCard: View {
    let event: ScheduledEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: event.type.icon)
                    .font(.title2)
                    .foregroundColor(maincolor)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(secondcolor)
                            .shadow(color: maincolor.opacity(0.2), radius: 3, x: 0, y: 2)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title)
                        .font(.headline)
                        .foregroundColor(maincolor)
                    
                    Text(event.date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Text(event.description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
            
            HStack {
                Image(systemName: event.isVirtual ? "video" : "mappin")
                Text(event.location)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            HStack {
                Button(action: {}) {
                    Text("View Details")
                        .font(.subheadline)
                        .foregroundColor(offwhite)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(maincolor)
                        .cornerRadius(20)
                }
                
                Spacer()
                
                ShareLink(item: "Check out this event: \(event.title)") {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(maincolor)
                }
            }
        }
        .frame(width: 300)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

struct UpcomingEventCard: View {
    let event: ScheduledEvent
    @Binding var showRegistrationAlert: Bool
    @Binding var registeredEventName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: event.type.icon)
                    .font(.title2)
                    .foregroundColor(maincolor)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(secondcolor)
                            .shadow(color: maincolor.opacity(0.2), radius: 3, x: 0, y: 2)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title)
                        .font(.headline)
                        .foregroundColor(maincolor)
                    
                    Text(event.date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if let cost = event.cost {
                    Text("$\(String(format: "%.2f", cost))")
                        .font(.headline)
                        .foregroundColor(maincolor)
                } else {
                    Text("Free")
                        .font(.headline)
                        .foregroundColor(.green)
                }
            }
            
            Text(event.description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
            
            HStack {
                Image(systemName: event.isVirtual ? "video" : "mappin")
                Text(event.location)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                if let max = event.maxAttendees {
                    Text("\(event.attendeeCount)/\(max) attending")
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    Text("\(event.attendeeCount) attending")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            HStack {
                Button(action: {
                    registeredEventName = event.title
                    showRegistrationAlert = true
                }) {
                    Text("Register")
                        .font(.subheadline)
                        .foregroundColor(offwhite)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(maincolor)
                        .cornerRadius(20)
                }
                
                Spacer()
                
                Button(action: {
                    // Add calendar functionality here
                }) {
                    Image(systemName: "calendar.badge.plus")
                        .foregroundColor(maincolor)
                }
                
                ShareLink(item: "Check out this event: \(event.title)") {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(maincolor)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

struct CreateEventButton: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(maincolor)
                .frame(width: 80, height: 80)
            
            Image(systemName: "plus")
                .resizable()
                .foregroundColor(offwhite)
                .frame(width: 25, height: 25)
        }
        .shadow(radius: 10)
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                
                Button("Done") {
                    isPresented = false
                }
                .padding()
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    EventsView()
}
