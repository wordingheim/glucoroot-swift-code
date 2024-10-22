import SwiftUI

struct messageScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State var txt: String = ""
    var body: some View {
        ZStack {
            secondcolor
                .ignoresSafeArea(.all)
            VStack {
                TextEditor(text: $txt)
                    .frame(height: 300) // Sets the height for the text box
                    .border(Color.gray, width: 1)
                    .padding()
                Button(action: {
                    fetchPosts() { success in
                        
                    }
                }) {
                    Text("GO")
                }
                Button(action: {
                    sendMessage(txt:txt) { success in
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

struct AddButton: View {
    var body: some View {
        NavigationLink(destination: messageScreen()) {
            
            ZStack {
                Circle()
                    .fill(maincolor)
                    .frame(width: 80, height: 80) // Set the circle size

                Image(systemName: "plus")
                    .resizable()
                    .foregroundColor(offwhite)
                    .frame(width: 25, height: 25) // Set the image size
            }
            .frame(width: 80, height: 80)
            .shadow(radius: 10)
        }
        .navigationTitle("Home")
    }
}

struct CommunityPage: View {
    @State private var activeTab = "feed"
    
    @State var pst : Array<Post> = []
    

    
    
    
    let posts = [
        Post(id: 1, author: "Emily R.", content: "Just hit my 100-day streak of logging meals! 🎉 This app has been a game-changer for me."),
             //, likes: 24, comments: 7),
        Post(id: 2, author: "Michael S.", content: "Question: Has anyone tried the new CGM device? Thinking about switching."),
             //, likes: 15, comments: 12),
        Post(id: 3, author: "Sophia L.", content: "Today's small win: Resisted the temptation of office donuts. Stay strong, everyone! 💪")
             //, likes: 32, comments: 5)
    ]
    
    let events = [
        Event(id: 1, title: "Diabetes Management Workshop", date: "May 15, 2024", attendees: 45),
        Event(id: 2, title: "Healthy Cooking Class", date: "May 22, 2024", attendees: 30)
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ZStack {
                    maincolor
                    VStack{
                        Spacer()
                            .frame(height:120)
                        Text("GlucoGuide Community")
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
                    
                    
                    // Main Content
                ScrollView {
                    VStack(spacing: 16) {
                        switch activeTab {
                        case "feed":
                            ForEach(pst) { post in
                                PostView(post: post)
                            }
                        case "groups":
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(["Type 1 Support", "Healthy Recipes", "Exercise Buddies", "Newcomers Welcome"], id: \.self) { group in
                                    GroupView(name: group)
                                }
                            }
                        case "events":
                            ForEach(events) { event in
                                EventView(event: event)
                            }
                        default:
                            EmptyView()
                        }
                    }
                    .padding()
                }.overlay(
                    VStack {
                        Button(action:{
                            fetchPosts() {response in
                                pst = response ?? pst
                            }
                        }){
                            Text("sneed")
                        }
                        AddButton()
                            .padding(20)
                        
                    },
                    alignment: .bottomTrailing
                    
                )
                    
            }
            .navigationBarHidden(true)
        }
        
        
    }
    
    
    func iconName(for item: String) -> String {
        switch item {
        case "Home": return "house"
        case "Nutrition": return "leaf"
        case "Community": return "person.3"
        case "Profile": return "person"
        default: return ""
        }
    }
}

struct PostView: View {
    @State var post: Post
    
    var body: some View {
        HStack{
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
                        Image(systemName: "heart")
                        //Text("\(post.likes)")
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "message")
                        //Text("\(post.comments)")
                    }
                }
                .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth:.infinity)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        
    }
}

struct GroupView: View {
    let name: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(name)
                .font(.headline)
                .foregroundColor(.green)
            
            Text("Join others in discussions, share experiences, and get support.")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Button("Join Group") {
                // Action
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(maincolor)
            .foregroundColor(offwhite)
            .cornerRadius(20)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct EventView: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.title)
                .font(.headline)
                .foregroundColor(.green)
            
            Text(event.date)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                Image(systemName: "person.3")
                Text("\(event.attendees) attending")
            }
            .font(.caption)
            .foregroundColor(.gray)
            
            Button("RSVP") {
                // Action
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(maincolor)
            .foregroundColor(offwhite)
            .cornerRadius(20)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct Post: Identifiable {
    let id: Int
    let author: String
    let content: String
    //let likes: Int
    //let comments: Int
}

struct Event: Identifiable {
    let id: Int
    let title: String
    let date: String
    let attendees: Int
}

struct CommunityPage_Previews: PreviewProvider {
    static var previews: some View {
        CommunityPage()
        //messageScreen()
    }
}
