import SwiftUI

struct MealPlanCalendar: View {
    @State private var viewMode: String = "week"
    @State private var currentDate: Date = Date()

    let calendar = Calendar.current

    // Function to get week dates
    func getWeekDates(for date: Date) -> [Date] {
        var week: [Date] = []
        let start = calendar.date(byAdding: .day, value: -calendar.component(.weekday, from: date) + 1, to: date)!
        for i in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: i, to: start) {
                week.append(day)
            }
        }
        return week
    }

    // Function to get month dates with empty slots for proper layout
    func getMonthDates(for date: Date) -> [Date] {
        var month: [Date] = []
        let start = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let range = calendar.range(of: .day, in: .month, for: start)!
        let firstDay = calendar.component(.weekday, from: start)

        // Add days from the previous month
        for i in 1..<firstDay {
            if let prevDate = calendar.date(byAdding: .day, value: -i, to: start) {
                month.append(prevDate)
            }
        }

        // Add days of the current month
        for day in range {
            if let currentDate = calendar.date(byAdding: .day, value: day - 1, to: start) {
                month.append(currentDate)
            }
        }

        // Add days from the next month to fill the week
        let lastDay = calendar.date(byAdding: .day, value: -1, to: calendar.date(byAdding: .month, value: 1, to: start)!)!
        let lastWeekday = calendar.component(.weekday, from: lastDay)
        for i in 1..<(8 - lastWeekday) {
            if let nextDate = calendar.date(byAdding: .day, value: i, to: lastDay) {
                month.append(nextDate)
            }
        }

        // Pad with empty dates for layout
        let totalDaysInMonth = 6 * 7 // 6 weeks, 7 days
        while month.count < totalDaysInMonth {
            month.append(Date.distantPast) // Use a distant past date as a placeholder
        }

        return month
    }

    // Function to get year dates
    func getYearDates(for year: Int) -> [Date] {
        return (0..<12).compactMap { month in
            calendar.date(from: DateComponents(year: year, month: month + 1, day: 1))
        }
    }

    // Function to navigate between weeks/months/years
    func navigateTime(direction: Int) {
        if viewMode == "week" {
            currentDate = calendar.date(byAdding: .day, value: direction * 7, to: currentDate)!
        } else if viewMode == "month" {
            currentDate = calendar.date(byAdding: .month, value: direction, to: currentDate)!
        } else if viewMode == "year" {
            currentDate = calendar.date(byAdding: .year, value: direction, to: currentDate)!
        }
    }

    // Function to navigate to a specific month
    func navigateToMonth(_ month: Int) {
        currentDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: currentDate), month: month))!
        viewMode = "month"
    }

    var body: some View {
        let dates: [Date]
        let title: String

        // DateFormatter for displaying the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium

        if viewMode == "week" {
            dates = getWeekDates(for: currentDate)
            title = "Week of \(dateFormatter.string(from: dates[0]))"
        } else if viewMode == "month" {
            dates = getMonthDates(for: currentDate)
            title = dateFormatter.string(from: currentDate)
        } else {
            dates = getYearDates(for: calendar.component(.year, from: currentDate))
            title = "\(calendar.component(.year, from: currentDate))"
        }

        return VStack {
            Text("Calendar")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.green)
                .padding()

            HStack {
                Button(action: { navigateTime(direction: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.green)
                }

                Spacer()

                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Button(action: { navigateTime(direction: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.title)
                        .foregroundColor(.green)
                }
            }
            .padding()

            if viewMode != "year" {
                Button(action: {
                    viewMode = viewMode == "week" ? "month" : "year"
                }) {
                    Text("View \(viewMode == "week" ? "Month" : "Year")")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            } else {
                Button(action: {
                    viewMode = "month"
                }) {
                    Text("View Month")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }

            if viewMode == "year" {
                // Display months in a grid for the year view
                let months = calendar.monthSymbols

                let columns = Array(repeating: GridItem(.flexible()), count: 3)

                LazyVGrid(columns: columns) {
                    ForEach(0..<months.count, id: \.self) { index in
                        Button(action: {
                            navigateToMonth(index + 1)
                        }) {
                            Text(months[index])
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green.opacity(0.3))
                                .cornerRadius(8)
                                .foregroundColor(.green)
                        }
                    }
                }
                .padding()
            } else {
                let columns = Array(repeating: GridItem(.flexible()), count: viewMode == "week" ? 7 : 7)

                LazyVGrid(columns: columns) {
                    if viewMode != "year" {
                        ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                            Text(day)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.green)
                        }
                    }

                    ForEach(dates, id: \.self) { date in
                        if date == Date.distantPast {
                            // Placeholder for empty days
                            Color.clear
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            Text("\(calendar.component(.day, from: date))")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(date == Date() ? Color.green.opacity(0.5) : Color.clear)
                                .cornerRadius(8)
                                .onTapGesture {
                                    print("Date clicked: \(date)")
                                }
                                .foregroundColor(viewMode == "month" && calendar.component(.month, from: date) != calendar.component(.month, from: currentDate) ? .gray : .black)
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color.green.opacity(0.1).ignoresSafeArea())
    }
}

struct MealPlanCalendar_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanCalendar()
    }
}
