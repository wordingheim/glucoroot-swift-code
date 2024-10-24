//
//  Community_FeedView.swift
//  DiabetesTest
//
//  Created by Ryan Lien on 10/23/24.
//
import SwiftUI

struct FeedView: View {
    @State private var posts: [Post] = []
    @State private var activeTab = "feed"  // Added for tab navigation
    
    // Sample data
    let samplePosts = [
        Post(id: 1, author: "Emily R.", content: "Just hit my 100-day streak of logging meals! 🎉 This app has been a game-changer for me."),
        Post(id: 2, author: "Michael S.", content: "Question: Has anyone tried the new CGM device? Thinking about switching."),
        Post(id: 3, author: "Sophia L.", content: "Today's small win: Resisted the temptation of office donuts. Stay strong, everyone! 💪")
    ]
    
    var body: some View {
        NavigationView {
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
                .shadow(radius: 2)
                .mask(Rectangle().padding(.bottom, -20))
                
                // Feed Content
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(posts) { post in
                            FeedPostView(post: post)
                        }
                    }
                    .padding()
                }
                .overlay(
                    VStack {
                        Spacer()
                        FeedAddButton()
                            .padding(20)
                    }
                )
            }
            .navigationBarHidden(true)
            .onAppear {
                fetchPosts { response in
                    posts = response ?? samplePosts
                }
            }
        }
    }
}

struct FeedPostView: View {
    let post: Post
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(String(post.author.prefix(1)))
                        .font(.headline)
                        .foregroundColor(maincolor)
                        .frame(width: 40, height: 40)
                        .background(secondcolor)
                        .clipShape(Circle())
                    
                    Text(post.author)
                        .font(.headline)
                }
                
                Text(post.content)
                    .font(.body)
                
                HStack {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "heart")
                        }
                    }
                    
                    Spacer()
                        .frame(width: 20)
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "message")
                        }
                    }
                }
                .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct FeedAddButton: View {
    var body: some View {
        NavigationLink(destination: FeedMessageScreen()) {
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

struct FeedMessageScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State var messageText: String = ""
    
    var body: some View {
        ZStack {
            secondcolor
                .ignoresSafeArea(.all)
            VStack {
                TextEditor(text: $messageText)
                    .frame(height: 300)
                    .border(Color.gray, width: 1)
                    .padding()
                
                Button(action: {
                    sendMessage(txt: messageText) { success in
                        print(success)
                        if success {
                            DispatchQueue.main.async {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }) {
                    Text("Add")
                        .foregroundColor(offwhite)
                        .padding()
                        .background(maincolor)
                }
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
