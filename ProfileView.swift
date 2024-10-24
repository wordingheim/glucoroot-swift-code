import SwiftUI

struct ProfileView: View {
    @State private var showingEditProfile = false
    @State private var isCGMConnected = false
    
    let profile = Profile(
        name: "Sarah Johnson",
        email: "sarah.johnson@example.com",
        age: "35",
        diabetesType: "Type 2",
        diagnosisYear: "2020",
        lastA1C: "6.5%",
        insulinType: "Lantus",
        dailyInsulinDose: "20 units"
    )
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ProfileHeader(profile: profile, showingEditProfile: $showingEditProfile)
                    
                    CGMConnectionCard(isConnected: $isCGMConnected)
                    
                    HealthOverview(profile: profile)
                    
                    UploadBloodwork()
                    
                    DiabetesAssessment()
                    
                    HealthMetrics()
                    
                    AccountSettings()
                }
                .padding()
            }
            .background(secondcolor)
            .navigationBarHidden(true)
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(profile: profile)
            }
        }
    }
}

struct Profile {
    let name: String
    let email: String
    let age: String
    let diabetesType: String
    let diagnosisYear: String
    let lastA1C: String
    let insulinType: String
    let dailyInsulinDose: String
}

struct ProfileHeader: View {
    let profile: Profile
    @Binding var showingEditProfile: Bool
    @Environment(\.isLoggedIn) var ilg
    @Environment(\.UserName) var usr
    @Environment(\.Name) var name
    @Environment(\.Email) var email
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
                    .background(maincolor)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(name.wrappedValue)
                        .font(.headline)
                    Text(email.wrappedValue)
                        .font(.caption)
                }
                
                Spacer()
                
                HStack(spacing: 10) {
                    Button(action: {
                        showingEditProfile = true
                    }) {
                        Image(systemName: "pencil")
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        logout() { success in
                            if success == true {
                                ilg.wrappedValue = false
                            }
                        }
                    }) {
                        Text("Log Out")
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            
            HStack {
                ProfileInfoItem(title: "Age", value: profile.age)
                ProfileInfoItem(title: "Type", value: profile.diabetesType)
                ProfileInfoItem(title: "Diagnosed", value: profile.diagnosisYear)
            }
        }
        .padding()
        .background(maincolor)
        .foregroundColor(.white)
        .cornerRadius(15)
    }
}

struct CGMConnectionCard: View {
    @Binding var isConnected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("CGM Device")
                .font(.headline)
            
            HStack {
                Image(systemName: isConnected ? "wave.3.right.circle.fill" : "wave.3.right.circle")
                    .font(.title2)
                    .foregroundColor(isConnected ? .green : .gray)
                
                VStack(alignment: .leading) {
                    Text(isConnected ? "CGM Connected" : "No CGM Connected")
                        .font(.subheadline)
                    Text(isConnected ? "Device is sending data" : "Connect your CGM device")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    isConnected.toggle()
                }) {
                    Text(isConnected ? "Disconnect" : "Connect")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(isConnected ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct ProfileInfoItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
        }
    }
}

struct HealthOverview: View {
    let profile: Profile
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Health Overview")
                .font(.headline)
            
            HStack {
                HealthInfoItem(title: "Last A1C", value: profile.lastA1C)
                HealthInfoItem(title: "Insulin Type", value: profile.insulinType)
                HealthInfoItem(title: "Daily Dose", value: profile.dailyInsulinDose)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct HealthInfoItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
            Text(value)
                .font(.caption)
        }
    }
}

struct EditProfileView: View {
    let profile: Profile
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Name", text: .constant(profile.name))
                    TextField("Email", text: .constant(profile.email))
                    TextField("Age", text: .constant(profile.age))
                }
                
                Section(header: Text("Medical Information")) {
                    TextField("Diabetes Type", text: .constant(profile.diabetesType))
                    TextField("Diagnosis Year", text: .constant(profile.diagnosisYear))
                    TextField("Insulin Type", text: .constant(profile.insulinType))
                    TextField("Daily Insulin Dose", text: .constant(profile.dailyInsulinDose))
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    // Add save logic here
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct UploadBloodwork: View {
    var body: some View {
        VStack {
            Text("Upload Bloodwork")
                .font(.headline)
            
            Button(action: {
                // Upload action
            }) {
                VStack {
                    Image(systemName: "arrow.up.doc")
                        .font(.largeTitle)
                    Text("Click to upload or drag and drop")
                        .font(.caption)
                    Text("PDF, JPG, PNG (MAX. 10MB)")
                        .font(.caption2)
                }
                .foregroundColor(maincolor)
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .background(maincolor.opacity(0.1))
            .cornerRadius(10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct DiabetesAssessment: View {
    @Environment(\.Email) var email
    @Environment(\.Percent) var percent
    
    var body: some View {
        VStack {
            Text("Diabetes Assessment")
                .font(.headline)
            
            NavigationLink(destination: Questions(questionsframe:questionsdict)) {
                HStack {
                    Text("Take Diabetes Risk Assessment")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(maincolor)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            NavigationLink(destination: DiabetesRiskResult(riskPercentage:percent.wrappedValue)) {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                    Text("View Quiz Results")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct HealthMetrics: View {
    let metrics = [
        ("chart.xyaxis.line", "A1C History", Color.blue),
        ("clipboard", "Lab Results", Color.green),
        ("bell", "Reminders", Color.yellow)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Health Metrics")
                .font(.headline)
            
            ForEach(metrics, id: \.0) { icon, label, color in
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(color)
                    Text(label)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 5)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct AccountSettings: View {
    let settings = [
        ("shield", "Privacy", Color.indigo),
        ("questionmark.circle", "Help & Support", Color.teal),
        ("gearshape", "App Settings", Color.gray)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Account Settings")
                .font(.headline)
            
            ForEach(settings, id: \.0) { icon, label, color in
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(color)
                    Text(label)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 5)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct ContentView1: View {
    var body: some View {
        TabView {
            DiabetesHomeDashboard()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            Text("Nutrition")
                .tabItem {
                    Image(systemName: "leaf")
                    Text("Nutrition")
                }
            Text("Community")
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Community")
                }
        }
        .accentColor(maincolor)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
