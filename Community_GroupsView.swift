//
//  Community_GroupsView.swift
//  DiabetesTest
//
//  Created by Ryan Lien on 10/23/24.
//

import SwiftUI

struct CommunityTabGroupsView: View {
    @State private var activeTab = "groups"
    @State private var showJoinAlert = false
    @State private var joinedGroupName = ""
    
    @State private var groups: [TabGroup] = [
        TabGroup(id: 1, name: "Type 1 Support", description: "Join others in discussions, share experiences, and get support.", memberCount: 156),
        TabGroup(id: 2, name: "Healthy Recipes", description: "Share and discover diabetes-friendly recipes and cooking tips.", memberCount: 234),
        TabGroup(id: 3, name: "Exercise Buddies", description: "Find workout partners and share fitness goals and achievements.", memberCount: 189),
        TabGroup(id: 4, name: "Newcomers Welcome", description: "A friendly space for those newly diagnosed or new to the community.", memberCount: 145)
    ]
    
    @State private var myGroups: [TabGroup] = [
        TabGroup(id: 5, name: "Daily Check-ins", description: "Share your daily progress and support others.", memberCount: 178),
        TabGroup(id: 6, name: "Tech Talk", description: "Discuss diabetes technology and devices.", memberCount: 145)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6)  // Light gray background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    ZStack {
                        secondcolor
                        VStack {
                            Spacer()
                                .frame(height: 120)
                            Text("GlucoRoot Community")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    .frame(height: 60)
                    .ignoresSafeArea(edges: .top)
                    
                    // Tab Navigation
                    HStack {
                        ForEach(["feed", "groups", "events"], id: \.self) { tab in
                            Button(action: {
                                activeTab = tab
                            }) {
                                Text(tab.capitalized)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(activeTab == tab ? maincolor : Color.clear)
                                    .foregroundColor(activeTab == tab ? offwhite : .gray)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(5)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .shadow(radius: 1)
                    
                    // Content
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            // My Groups Section
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("My Groups")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    Button(action: {}) {
                                        Text("See All")
                                            .font(.subheadline)
                                            .foregroundColor(maincolor)
                                    }
                                }
                                .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(myGroups) { group in
                                            MyGroupItemView(group: group)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.top, 16)
                            
                            // Divider with spacing
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 8)
                                .padding(.vertical, 8)
                            
                            // Discover Groups Section
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Discover Groups")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    Menu {
                                        Button("Most Popular", action: {})
                                        Button("Recently Added", action: {})
                                        Button("Alphabetical", action: {})
                                    } label: {
                                        Image(systemName: "slider.horizontal.3")
                                            .foregroundColor(maincolor)
                                    }
                                }
                                .padding(.horizontal)
                                
                                LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                                    ForEach(groups) { group in
                                        TabGroupItemView(group: group, showJoinAlert: $showJoinAlert, joinedGroupName: $joinedGroupName)
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
                            TabGroupCreateButton()
                                .padding(20)
                        }
                    )
                }
            }
            .navigationBarHidden(true)
            .alert("Group Joined!", isPresented: $showJoinAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("You have successfully joined \(joinedGroupName)")
            }
        }
    }
}

struct MyGroupItemView: View {
    let group: TabGroup
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Text(String(group.name.prefix(1)))
                    .font(.headline)
                    .foregroundColor(maincolor)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(secondcolor)
                            .shadow(color: maincolor.opacity(0.2), radius: 3, x: 0, y: 2)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(group.name)
                        .font(.headline)
                        .foregroundColor(maincolor)
                    
                    HStack {
                        Image(systemName: "person.3")
                        Text("\(group.memberCount) members")
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }
            }
            
            Text(group.description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
                .padding(.horizontal, 4)
            
            Button(action: {}) {
                HStack {
                    Text("View Group")
                    Image(systemName: "chevron.right")
                }
                .font(.subheadline)
                .foregroundColor(offwhite)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(maincolor)
                .cornerRadius(20)
            }
        }
        .frame(width: 280)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

struct TabGroupItemView: View {
    let group: TabGroup
    @Binding var showJoinAlert: Bool
    @Binding var joinedGroupName: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text(String(group.name.prefix(1)))
                .font(.headline)
                .foregroundColor(maincolor)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(secondcolor)
                        .shadow(color: maincolor.opacity(0.2), radius: 3, x: 0, y: 2)
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(group.name)
                    .font(.headline)
                    .foregroundColor(maincolor)
                
                Text(group.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "person.3")
                        Text("\(group.memberCount) members")
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button(action: {
                        joinedGroupName = group.name
                        showJoinAlert = true
                    }) {
                        Text("Join")
                            .font(.subheadline)
                            .foregroundColor(offwhite)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 16)
                            .background(maincolor)
                            .cornerRadius(20)
                    }
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

struct TabGroupCreateButton: View {
    var body: some View {
        NavigationLink(destination: TabGroupCreateScreen()) {
            ZStack {
                Circle()
                    .fill(maincolor)
                    .frame(width: 80, height: 80)
                
                Image(systemName: "plus")
                    .resizable()
                    .foregroundColor(offwhite)
                    .frame(width: 25, height: 25)
            }
            .frame(width: 80, height: 80)
            .shadow(radius: 10)
        }
    }
}

struct TabGroupCreateScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State var groupName: String = ""
    @State var groupDescription: String = ""
    
    var body: some View {
        ZStack {
            secondcolor
                .ignoresSafeArea(.all)
            VStack(spacing: 20) {
                TextField("Group Name", text: $groupName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextEditor(text: $groupDescription)
                    .frame(height: 200)
                    .border(Color.gray, width: 1)
                    .padding()
                
                Button(action: {
                    createGroup(name: groupName, description: groupDescription) { success in
                        print(success)
                        if success {
                            DispatchQueue.main.async {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }) {
                    Text("Create Group")
                        .foregroundColor(offwhite)
                        .padding()
                        .background(maincolor)
                        .cornerRadius(10)
                }
            }
        }
    }
}

struct TabGroup: Identifiable {
    let id: Int
    let name: String
    let description: String
    let memberCount: Int
}

// Placeholder for network functions
func fetchGroups(completion: @escaping ([TabGroup]?) -> Void) {
    // Implementation to be provided
}

func createGroup(name: String, description: String, completion: @escaping (Bool) -> Void) {
    // Implementation to be provided
}

#Preview {
    CommunityTabGroupsView()
}
