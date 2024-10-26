import SwiftUI


struct CalendarView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDate: Date = Date()
    @State private var calendarViewMode: CalendarMode = .week
    @State private var selectedViewDate: Date = Date()
    @State private var selectedHour: Date?
    @State private var showingHourlyView: Bool = false
    
    enum CalendarMode {
        case week, month, year
    }
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    private let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                calendarHeader
                modeSelector
                
                ScrollView {
                    VStack(spacing: 15) {
                        switch calendarViewMode {
                        case .week:
                            WeekView(selectedDate: $selectedDate,
                                   viewDate: $selectedViewDate,
                                   showingHourlyView: $showingHourlyView)
                        case .month:
                            MonthView(selectedDate: $selectedDate,
                                    viewDate: $selectedViewDate,
                                    showingHourlyView: $showingHourlyView)
                        case .year:
                            YearView(selectedDate: $selectedDate,
                                   viewDate: $selectedViewDate,
                                   showingHourlyView: $showingHourlyView)
                        }
                        
                        if showingHourlyView {
                            VStack(alignment: .leading) {
                                Text("Schedule for \(dateFormatter.string(from: selectedDate))")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                HourlyView(date: selectedDate, selectedHour: $selectedHour)
                            }
                            .padding(.top)
                            .background(thirdcolor)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(bordercolor, lineWidth: 1)
                            )
                        }
                    }
                }
                .background(thirdcolor)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(bordercolor, lineWidth: 1)
                )
            }
            .padding()
            .background(secondcolor.opacity(0.6).edgesIgnoringSafeArea(.all))
            .navigationTitle("Calendar")
            .navigationBarItems(leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Nutrition View")
                    }
                    .foregroundColor(maincolor)
                }
            )
        }
    }
    
    var calendarHeader: some View {
        HStack {
            Button(action: decrementDate) {
                Image(systemName: "chevron.left")
                    .foregroundColor(maincolor)
            }
            
            Spacer()
            
            Text(formattedHeaderDate)
                .font(.headline)
                .foregroundColor(textcolor)
            
            Spacer()
            
            Button(action: incrementDate) {
                Image(systemName: "chevron.right")
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
    
    var modeSelector: some View {
        HStack {
            ForEach([CalendarMode.week, .month, .year], id: \.self) { mode in
                Button(action: {
                    calendarViewMode = mode
                    showingHourlyView = false
                }) {
                    Text(String(describing: mode).capitalized)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(calendarViewMode == mode ? maincolor : thirdcolor)
                        .foregroundColor(calendarViewMode == mode ? thirdcolor : textcolor)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(bordercolor, lineWidth: 1)
                        )
                }
            }
        }
    }
    
    var formattedHeaderDate: String {
        switch calendarViewMode {
        case .week:
            return "Week of \(monthFormatter.string(from: selectedViewDate))"
        case .month:
            return monthFormatter.string(from: selectedViewDate)
        case .year:
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            return yearFormatter.string(from: selectedViewDate)
        }
    }
    
    func decrementDate() {
        switch calendarViewMode {
        case .week:
            selectedViewDate = calendar.date(byAdding: .weekOfYear, value: -1, to: selectedViewDate) ?? selectedViewDate
        case .month:
            selectedViewDate = calendar.date(byAdding: .month, value: -1, to: selectedViewDate) ?? selectedViewDate
        case .year:
            selectedViewDate = calendar.date(byAdding: .year, value: -1, to: selectedViewDate) ?? selectedViewDate
        }
    }
    
    func incrementDate() {
        switch calendarViewMode {
        case .week:
            selectedViewDate = calendar.date(byAdding: .weekOfYear, value: 1, to: selectedViewDate) ?? selectedViewDate
        case .month:
            selectedViewDate = calendar.date(byAdding: .month, value: 1, to: selectedViewDate) ?? selectedViewDate
        case .year:
            selectedViewDate = calendar.date(byAdding: .year, value: 1, to: selectedViewDate) ?? selectedViewDate
        }
    }
}

struct HourlyView: View {
    let date: Date
    @Binding var selectedHour: Date?
    private let calendar = Calendar.current
    private let hourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(0..<24) { hour in
                    if let hourDate = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: date) {
                        HourCell(
                            time: hourDate,
                            isSelected: calendar.isDate(hourDate, equalTo: selectedHour ?? Date(), toGranularity: .hour),
                            formatter: hourFormatter
                        )
                        .onTapGesture {
                            selectedHour = hourDate
                        }
                        Divider()
                    }
                }
            }
        }
        .frame(maxHeight: 300)
    }
}

struct HourCell: View {
    let time: Date
    let isSelected: Bool
    let formatter: DateFormatter
    
    var body: some View {
        HStack {
            Text(formatter.string(from: time))
                .padding(.vertical, 8)
                .padding(.horizontal)
            Spacer()
        }
        .background(isSelected ? maincolor.opacity(0.1) : Color.clear)
        .contentShape(Rectangle())
    }
}

struct WeekView: View {
    @Binding var selectedDate: Date
    @Binding var viewDate: Date
    @Binding var showingHourlyView: Bool
    private let calendar = Calendar.current
    
    var body: some View {
        HStack {
            ForEach(getDaysOfWeek(), id: \.self) { date in
                DayCell(
                    date: date,
                    isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                    isToday: calendar.isDate(date, inSameDayAs: Date()),
                    showingHourlyView: $showingHourlyView
                )
                .onTapGesture {
                    selectedDate = date
                    withAnimation {
                        showingHourlyView = true
                    }
                }
            }
        }
        .padding()
    }
    
    func getDaysOfWeek() -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: viewDate)
        let dayOfWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
        return days
    }
}

struct MonthView: View {
    @Binding var selectedDate: Date
    @Binding var viewDate: Date
    @Binding var showingHourlyView: Bool
    private let calendar = Calendar.current
    private let daysInWeek = 7
    
    var body: some View {
        VStack {
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(textcolor)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: daysInWeek)) {
                ForEach(getDaysInMonth(), id: \.self) { date in
                    if let date = date {
                        DayCell(
                            date: date,
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            isToday: calendar.isDate(date, inSameDayAs: Date()),
                            showingHourlyView: $showingHourlyView
                        )
                        .onTapGesture {
                            selectedDate = date
                            withAnimation {
                                showingHourlyView = true
                            }
                        }
                    } else {
                        Text("")
                            .frame(height: 40)
                    }
                }
            }
        }
        .padding()
    }
    
    func getDaysInMonth() -> [Date?] {
        let interval = calendar.dateInterval(of: .month, for: viewDate)!
        let firstDay = interval.start
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        let daysInMonth = calendar.range(of: .day, in: .month, for: viewDate)!.count
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(date)
            }
        }
        
        let remainingDays = (daysInWeek - (days.count % daysInWeek)) % daysInWeek
        days.append(contentsOf: Array(repeating: nil, count: remainingDays))
        
        return days
    }
}

struct YearView: View {
    @Binding var selectedDate: Date
    @Binding var viewDate: Date
    @Binding var showingHourlyView: Bool
    private let calendar = Calendar.current
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
            ForEach(1...12, id: \.self) { month in
                if let date = calendar.date(byAdding: .month, value: month - 1, to: startOfYear()) {
                    MonthThumbnail(
                        date: date,
                        isSelected: calendar.isDate(date, equalTo: selectedDate, toGranularity: .month),
                        isCurrentMonth: calendar.isDate(date, equalTo: Date(), toGranularity: .month)
                    )
                    .onTapGesture {
                        selectedDate = date
                        withAnimation {
                            showingHourlyView = true
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    func startOfYear() -> Date {
        let components = calendar.dateComponents([.year], from: viewDate)
        return calendar.date(from: components)!
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    @Binding var showingHourlyView: Bool
    private let calendar = Calendar.current
    
    var body: some View {
        Text(String(calendar.component(.day, from: date)))
            .frame(maxWidth: .infinity, minHeight: 40)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(isSelected ? maincolor : Color.clear, lineWidth: 2)
            )
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return maincolor.opacity(0.3)
        } else if isToday {
            return maincolor.opacity(0.1)
        }
        return Color.clear
    }
    
    private var foregroundColor: Color {
        if isSelected || isToday {
            return maincolor
        }
        return textcolor
    }
}

struct MonthThumbnail: View {
    let date: Date
    let isSelected: Bool
    let isCurrentMonth: Bool
    private let calendar = Calendar.current
    
    var body: some View {
        VStack {
            Text(DateFormatter().monthSymbols[calendar.component(.month, from: date) - 1])
                .font(.headline)
                .foregroundColor(foregroundColor)
            Text(String(calendar.component(.year, from: date)))
                .font(.caption)
                .foregroundColor(textcolor)
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? maincolor : bordercolor, lineWidth: 1)
        )
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return maincolor.opacity(0.3)
        } else if isCurrentMonth {
            return maincolor.opacity(0.1)
        }
        return thirdcolor
    }
    
    private var foregroundColor: Color {
        if isSelected || isCurrentMonth {
            return maincolor
        }
        return textcolor
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
