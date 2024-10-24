//
//  MakingGroupScreen.swift
//  DiabetesTest
//
//  Created by Ryan Lien on 10/24/24.
//

import SwiftUI
import PhotosUI

struct CommunityGroup: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var category: GroupCategory
    var tags: [String]
    var isPrivate: Bool
    var groupPhotoData: Data?
    var dateCreated: Date
    var memberLimit: Int
}

enum GroupCategory: String, CaseIterable, Identifiable {
    case support = "Support Group"
    case lifestyle = "Lifestyle & Diet"
    case exercise = "Fitness"
    case education = "Education"
    case research = "Research & News"
    case socializing = "Social"
    case other = "Other"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .support: return "heart.circle"
        case .lifestyle: return "leaf"
        case .exercise: return "figure.walk"
        case .education: return "book"
        case .research: return "newspaper"
        case .socializing: return "person.3"
        case .other: return "ellipsis.circle"
        }
    }
}

struct MakingGroupScreen: View {
    @State private var groupName: String = ""
    @State private var description: String = ""
    @State private var selectedCategory: GroupCategory = .support
    @State private var selectedTags: Set<String> = []
    @State private var isPrivate: Bool = false
    @State private var memberLimit: String = "50"
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    
    let availableTags = ["Type 1", "Type 2", "Newly Diagnosed", "Caregivers",
                        "Diet Support", "Exercise", "Mental Health", "Technology",
                        "Young Adults", "Seniors", "Parents"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    groupCreationForm
                }
                .padding()
            }
            .navigationTitle("Create Group")
            .background(secondcolor.opacity(0.6).edgesIgnoringSafeArea(.all))
        }
    }
    
    var groupCreationForm: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Group Photo
            PhotosPicker(selection: $selectedPhotoItem,
                        matching: .images) {
                VStack {
                    if let photoData = selectedPhotoData,
                       let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(bordercolor, lineWidth: 2))
                    } else {
                        Image(systemName: "person.3.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(maincolor)
                    }
                    Text("Add Group Photo")
                        .font(.caption)
                        .foregroundColor(maincolor)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom)
            
            // Group Name
            Text("Group Name")
                .foregroundColor(textcolor)
            TextField("Enter group name", text: $groupName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(textcolor)
            
            // Category Selection
            Text("Category")
                .foregroundColor(textcolor)
            Menu {
                ForEach(GroupCategory.allCases) { category in
                    Button(action: {
                        selectedCategory = category
                    }) {
                        HStack {
                            Image(systemName: category.icon)
                            Text(category.rawValue)
                        }
                    }
                }
            } label: {
                HStack {
                    Image(systemName: selectedCategory.icon)
                    Text(selectedCategory.rawValue)
                        .foregroundColor(textcolor)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(maincolor)
                }
                .padding()
                .background(thirdcolor)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(bordercolor, lineWidth: 1)
                )
            }
            
            // Description
            Text("Description")
                .foregroundColor(textcolor)
            TextEditor(text: $description)
                .frame(height: 150)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(bordercolor, lineWidth: 1)
                )
            
            // Privacy Setting
            Toggle(isOn: $isPrivate) {
                HStack {
                    Image(systemName: isPrivate ? "lock" : "lock.open")
                    Text(isPrivate ? "Private Group" : "Public Group")
                }
                .foregroundColor(textcolor)
            }
            .toggleStyle(SwitchToggleStyle(tint: maincolor))
            
            // Member Limit
            Text("Member Limit")
                .foregroundColor(textcolor)
            TextField("Maximum number of members", text: $memberLimit)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .foregroundColor(textcolor)
            
            // Tags
            Text("Tags")
                .foregroundColor(textcolor)
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
            
            // Create Button
            Button(action: createGroup) {
                Text("Create Group")
                    .foregroundColor(thirdcolor)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(maincolor)
                    .cornerRadius(10)
            }
            .disabled(groupName.isEmpty || description.isEmpty)
        }
        .padding()
        .background(thirdcolor)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(bordercolor, lineWidth: 1)
        )
        .onChange(of: selectedPhotoItem) { _ in
            Task {
                if let data = try? await selectedPhotoItem?.loadTransferable(type: Data.self) {
                    selectedPhotoData = data
                }
            }
        }
    }
    
    func createGroup() {
        let group = CommunityGroup(
            name: groupName,
            description: description,
            category: selectedCategory,
            tags: Array(selectedTags),
            isPrivate: isPrivate,
            groupPhotoData: selectedPhotoData,
            dateCreated: Date(),
            memberLimit: Int(memberLimit) ?? 50
        )
        // Here you would save the group to your data store
        resetForm()
    }
    
    func resetForm() {
        groupName = ""
        description = ""
        selectedCategory = .support
        selectedTags.removeAll()
        isPrivate = false
        memberLimit = "50"
        selectedPhotoData = nil
        selectedPhotoItem = nil
    }
}

struct MakingGroupScreen_Previews: PreviewProvider {
    static var previews: some View {
        MakingGroupScreen()
    }
}
