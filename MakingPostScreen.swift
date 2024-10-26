//
//  MakingPostScreen.swift
//  DiabetesTest
//
//  Created by Ryan Lien on 10/23/24.
//

import SwiftUI
import PhotosUI

struct CommunityPost: Identifiable {
    let id = UUID()
    var title: String
    var content: String
    var category: PostCategory
    var tags: [String]
    var photoData: Data?
    var datePosted: Date
}

enum PostCategory: String, CaseIterable, Identifiable {
    case meal = "Meal"
    case exercise = "Exercise"
    case motivation = "Motivation"
    case medication = "Medication"
    case tips = "Tips & Tricks"
    case question = "Question"
    case other = "Other"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .meal: return "fork.knife"
        case .exercise: return "figure.walk"
        case .motivation: return "star"
        case .medication: return "pill"
        case .tips: return "lightbulb"
        case .question: return "questionmark.circle"
        case .other: return "ellipsis.circle"
        }
    }
}

struct CommunityPostCreationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var selectedCategory: PostCategory = .meal
    @State private var selectedTags: Set<String> = []
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    
    let availableTags = ["Breakfast", "Lunch", "Dinner", "Snack", "Type 1", "Type 2",
                        "Low Carb", "High Protein", "Beginner", "Success Story"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    postCreationForm
                }
                .padding()
            }
            .navigationTitle("Create Post")
            .navigationBarItems(leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back to Community")
                    }
                    .foregroundColor(maincolor)
                }
            )
            .background(secondcolor.opacity(0.6).edgesIgnoringSafeArea(.all))
        }
    }
    
    var postCreationForm: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Title Input
            Text("Title")
                .foregroundColor(textcolor)
            TextField("What's on your mind?", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(textcolor)
            
            // Category Selection
            Text("Category")
                .foregroundColor(textcolor)
            Menu {
                ForEach(PostCategory.allCases) { category in
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
            
            // Content Input
            Text("Content")
                .foregroundColor(textcolor)
            TextEditor(text: $content)
                .frame(height: 150)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(bordercolor, lineWidth: 1)
                )
            
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
            
            // Photo Selection
            PhotosPicker(selection: $selectedPhotoItem,
                        matching: .images) {
                HStack {
                    Image(systemName: "camera")
                    Text("Add Photo")
                }
                .foregroundColor(maincolor)
                .padding()
                .background(thirdcolor)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(bordercolor, lineWidth: 1)
                )
            }
            
            if let photoData = selectedPhotoData,
               let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            }
            
            // Post Button
            Button(action: createPost) {
                Text("Post")
                    .foregroundColor(thirdcolor)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(maincolor)
                    .cornerRadius(10)
            }
            .disabled(title.isEmpty || content.isEmpty)
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
    
    func createPost() {
        let post = CommunityPost(
            title: title,
            content: content,
            category: selectedCategory,
            tags: Array(selectedTags),
            photoData: selectedPhotoData,
            datePosted: Date()
        )
        // Here you would save the post to your data store
        resetForm()
    }
    
    func resetForm() {
        title = ""
        content = ""
        selectedCategory = .meal
        selectedTags.removeAll()
        selectedPhotoData = nil
        selectedPhotoItem = nil
    }
}

// Reusing the TagButton from your existing code
struct CommunityPostCreationView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityPostCreationView()
    }
}
