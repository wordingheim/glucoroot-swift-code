import SwiftUI

struct ProfileView: View {
    //@Binding var isloggedin: Bool
    
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
                    ProfileHeader(profile: profile)
                    
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
                
                Button(action: {
                    logout() {success in
                        if success == true {
                            ilg.wrappedValue = false
                            //login = false
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
    var body: some View {
        VStack {
            Text("Diabetes Assessment")
                .font(.headline)
            
            Button(action: {
                // View quiz results action
            }) {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                    Text("View Quiz Results")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.orange)
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
            //ProfileView()
                //.tabItem {
                    //Image(systemName: "person")
                    //Text("Profile")
                //}
            
        }.accentColor(maincolor)
    }
}

struct abc: PreviewProvider {
    static var previews: some View {
        ContentView1()
    }
}
