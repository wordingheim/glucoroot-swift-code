//
//  Dashboard.swift
//  ML Test
//
//  Created by Minseo Kim on 10/9/24.
//
import SwiftUI
import Charts

struct HomeScreenTabs: View{
    @State private var activeTab = "Home"
    //@Binding var isloggedin: Bool
    //@Binding var username: String
    var body: some View {
        VStack{
            switch activeTab {
                case "Home":
                    DiabetesHomeDashboard()
                case "Nutrition":
                    NutritionPage()
                case "Community":
                    CommunityPage()
                case "Profile":
                    ProfileView()
                //ProfileView(isloggedin:$isloggedin)
                default:
                    Text("Unknown View")
                }
        }.overlay(
            TabBar(activeTab: $activeTab),
            alignment: .bottom
            
        ).ignoresSafeArea(edges: .bottom)
        
    }
}

struct DiabetesHomeDashboard: View {
    @State private var activeTab = "Home"
    @State private var activeView = "daily"
    
    let currentBGL = 115
    let avgBGLToday = 122
    let highestBGLToday = 140
    let lowestBGLToday = 95
    let nextInsulinTime = "6:30 PM"
    
    let mockDailyData = [
        GlucoseReading(time: "6am", glucose: 120),
        GlucoseReading(time: "9am", glucose: 140),
        GlucoseReading(time: "12pm", glucose: 100),
        GlucoseReading(time: "3pm", glucose: 110),
        GlucoseReading(time: "6pm", glucose: 130),
        GlucoseReading(time: "9pm", glucose: 115)
    ]
    
    let mockWeeklyData = [
        WeeklyGlucose(day: "Mon", avgGlucose: 118),
        WeeklyGlucose(day: "Tue", avgGlucose: 125),
        WeeklyGlucose(day: "Wed", avgGlucose: 115),
        WeeklyGlucose(day: "Thu", avgGlucose: 122),
        WeeklyGlucose(day: "Fri", avgGlucose: 128),
        WeeklyGlucose(day: "Sat", avgGlucose: 130),
        WeeklyGlucose(day: "Sun", avgGlucose: 120)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Text("Diabetes Dashboard")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(maincolor)
                        Spacer()
                        Text("Next Insulin: \(nextInsulinTime)")
                            .font(.caption)
                            .padding(8)
                            .background(thirdcolor)
                            .foregroundColor(textcolor)
                            .cornerRadius(8)
                            /*.overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(bordercolor, lineWidth: 2)
                            )*/
                            .shadow(radius: 5)
                    }
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        MetricCard(icon: "heart.fill", value: "\(currentBGL) mg/dL", label: "Current BGL", color: maincolor)
                        MetricCard(icon: "arrow.up.right", value: "\(avgBGLToday) mg/dL", label: "Avg Today", color: maincolor)
                        MetricCard(icon: "arrow.up", value: "\(highestBGLToday) mg/dL", label: "Highest Today", color: maincolor)
                        MetricCard(icon: "arrow.down", value: "\(lowestBGLToday) mg/dL", label: "Lowest Today", color: maincolor)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Blood Glucose Trend")
                            .font(.headline)
                            .foregroundColor(textcolor)
                        
                        Picker("View", selection: $activeView) {
                            Text("Daily").tag("daily")
                                .foregroundColor(textcolor)
                            Text("Weekly").tag("weekly")
                                .foregroundColor(textcolor)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        if activeView == "daily" {
                            Chart(mockDailyData) { reading in
                                LineMark(
                                    x: .value("Time", reading.time),
                                    y: .value("Glucose", reading.glucose)
                                )
                                .foregroundStyle(textcolor)
                            }
                            .frame(height: 200)
                        } else {
                            Chart(mockWeeklyData) { reading in
                                LineMark(
                                    x: .value("Day", reading.day),
                                    y: .value("Avg Glucose", reading.avgGlucose)
                                )
                                .foregroundStyle(textcolor)
                            }
                            
                            .frame(height: 200)
                            .foregroundStyle(textcolor)
                        }
                    }
                    .padding()
                    .background(thirdcolor)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(bordercolor, lineWidth: 2)
                    )
                    //.shadow(radius: 5)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Quick Actions")
                            .font(.headline)
                            .foregroundColor(textcolor)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ActionButton(icon: "drop.fill", label: "Log Blood Sugar", color: .green) {
                                // Handle action
                            }
                            ActionButton(icon: "pill.fill", label: "Log Medication", color: .blue) {
                                // Handle action
                            }
                            ActionButton(icon: "bell.fill", label: "Set Reminders", color: .yellow) {
                                // Handle action
                            }
                            ActionButton(icon: "checklist", label: "Risk Assessment", color: .purple) {
                                // Handle action
                            }
                        }
                    }
                    .padding()
                    .background(thirdcolor)
                    .cornerRadius(12)
                    //.shadow(radius: 5)
                    
                    Button(action: {
                        // Open AI Assistant chat
                    }) {
                        HStack {
                            Image(systemName: "brain")
                            Text("Chat with AI Assistant")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.bottom, 30)
                    }
                }
                .padding()
            }
            .background(secondcolor)
            .navigationBarHidden(true)
        }
    }
}

struct MetricCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }
            Text(value)
                .font(.headline)
                .foregroundColor(textcolor)
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(thirdcolor)
        .cornerRadius(12)
        .shadow(radius: 3)
        /*.overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(bordercolor, lineWidth: 2)
        )*/
        
    }
}

struct ActionButton: View {
    let icon: String
    let label: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(label)
                    .font(.caption)
                    .foregroundColor(textcolor)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(radius:5)
            /*.overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(bordercolor, lineWidth: 2)
            )*/
        }
    }
}

struct TabBar: View {
    @Binding var activeTab: String
    let spacerwidth = 25.0
    
    var body: some View {
        HStack {
            TabBarButton(imageName: "house.fill", title: "Home", isActive: activeTab == "Home") {
                activeTab = "Home"
            }
            Spacer()
                .frame(width:spacerwidth)
            TabBarButton(imageName: "leaf.fill", title: "Nutrition", isActive: activeTab == "Nutrition") {
                activeTab = "Nutrition"
            }
            Spacer()
                .frame(width:spacerwidth)
            TabBarButton(imageName: "person.3.fill", title: "Community", isActive: activeTab == "Community") {
                activeTab = "Community"
            }
            Spacer()
                .frame(width:spacerwidth)
            TabBarButton(imageName: "person.crop.circle", title: "Profile", isActive: activeTab == "Profile") {
                activeTab = "Profile"
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .shadow(radius: 5)
        
    }
}

struct TabBarButton: View {
    let imageName: String
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: imageName)
                    .font(.system(size: 10))
                Text(title)
                    .font(.caption2)
            }
            .foregroundColor(isActive ? maincolor : .gray)
        }
    }
}

struct GlucoseReading: Identifiable {
    let id = UUID()
    let time: String
    let glucose: Int
}

struct WeeklyGlucose: Identifiable {
    let id = UUID()
    let day: String
    let avgGlucose: Int
}


