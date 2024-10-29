//
//  TabScreen.swift
//  ML Test
//
//  Created by Minseo Kim on 10/27/24.
//

import SwiftUI

struct t_key: Identifiable {
    let id = UUID() // Unique identifier for each item
    let name: String
    let content: AnyView // Use AnyView for generic view content
}

let t_views: [t_key] = [
    t_key(name: "feed", content: AnyView(NavigationView{feed_v()})),
    t_key(name: "groups1", content: AnyView(NavigationView{group_v()})),
    //t_key(name: "gr", content: AnyView(CommunityTabGroupsView())),
    t_key(name: "events", content: AnyView(NavigationView{events_v()})),
]


struct feed_v: View {
    @State var pst : Array<Post> = []
    var body: some View{
        ScrollScreen(content:
            ForEach(pst) { post in
                PostView(post: post)
        }).onAppear() {
            update()
        }.overlay(
            AddBTN(dest:messageScreen()), alignment:.bottom
        )
    }
    
    private func update() {
        fetchPosts() {response in
            pst = response ?? pst
        }
    }
}

struct group_v: View {
    
    @State var grps : Array<GroupStruct> = []
    @State var usrgrps : Array<GroupStruct> = []
    @State var dscvgrps : Array<GroupStruct> = []
    
    var body: some View {
        ScrollScreen(content:
            VStack{
                smallHeader(text:"My Groups")
                .onAppear {
                    updateinit()
                    update()
                }
                ScrollScreen(content:
                    HStack{
                        ForEach(usrgrps) { group in
                            MyGroupItemView(group: group, grps: $grps, usrgrps: $usrgrps, dscvgrps: $dscvgrps)
                        }
                    }
                    ,dir:.horizontal
                )
                smallHeader(text:"Discover Groups")
                ForEach(dscvgrps) { group in
                    TabGroupView(group: group, grps:$grps, usrgrps: $usrgrps, dscvgrps:$dscvgrps)
                }.onAppear {
                    update()
                }
            }
        )
    }
    
    func updateinit() {
        print("getting groups")
        getGroups() {response in
            //print(response)
            grps = response ?? grps
            update()
        }
    }
    
    
    func update() {
        getUserGroups(user: "minseokim") {success, response in
            if success {
                usrgrps = response
            }
            dscvgrps = grps.filter { !usrgrps.contains($0) }
        }
        
    }
}
struct events_v: View {
    var filteredMyEvents: [ScheduledEvent] {
        let filtered = myEvents.filter { event in
            if let filter = selectedFilter {
                return event.type == filter
            }
            return true
        }
        return filtered.sorted { $0.date < $1.date }
    }
    
    var filteredUpcomingEvents: [ScheduledEvent] {
        let filtered = upcomingEvents.filter { event in
            if let filter = selectedFilter {
                return event.type == filter
            }
            return true
        }
        return filtered.sorted { $0.date < $1.date }
    }
    @State private var activeTab = "events"
    @State private var showRegistrationAlert = false
    @State private var registeredEventName = ""
    @State private var selectedFilter: ScheduledEventType? = nil
    @State private var showDatePicker = false
    @State private var selectedDate = Date()
    
    @State private var myEvents: [ScheduledEvent] = [
        ScheduledEvent(id: 1,
              title: "Weekly T1D Check-in",
              type: .supportGroup,
              description: "Join our weekly support group meeting to share experiences and tips.",
              date: Date().addingTimeInterval(86400),
              endDate: Date().addingTimeInterval(90000),
              location: "Zoom",
              isVirtual: true,
              host: "Sarah Johnson",
              attendeeCount: 15,
              maxAttendees: 20,
              cost: nil,
              isRegistered: true),
        ScheduledEvent(id: 2,
              title: "Diabetes-Friendly Cooking",
              type: .cooking,
              description: "Learn to prepare low-carb meals that don't compromise on taste.",
              date: Date().addingTimeInterval(172800),
              endDate: Date().addingTimeInterval(180000),
              location: "Community Center",
              isVirtual: false,
              host: "Chef Mike Brown",
              attendeeCount: 12,
              maxAttendees: 15,
              cost: 25.0,
              isRegistered: true)
    ]
    
    @State private var upcomingEvents: [ScheduledEvent] = [
        ScheduledEvent(id: 3,
              title: "Morning Yoga for Diabetics",
              type: .exercise,
              description: "Gentle yoga session suitable for all fitness levels.",
              date: Date().addingTimeInterval(259200),
              endDate: Date().addingTimeInterval(266400),
              location: "City Park",
              isVirtual: false,
              host: "Lisa Chen",
              attendeeCount: 8,
              maxAttendees: 20,
              cost: 15.0),
        ScheduledEvent(id: 4,
              title: "New Technology Workshop",
              type: .workshop,
              description: "Learn about the latest diabetes management technologies.",
              date: Date().addingTimeInterval(432000),
              endDate: Date().addingTimeInterval(439200),
              location: "Zoom",
              isVirtual: true,
              host: "Dr. James Wilson",
              attendeeCount: 45,
              maxAttendees: 100,
              cost: nil)
    ]
    var body: some View {
        ScrollScreen(content: VStack{
            smallHeader(text: "My Events")
            ScrollScreen(content: HStack {
                ForEach(filteredMyEvents) { event in
                    MyEventCard(event: event)
                }
            }, dir: .horizontal)
            
            smallHeader(text:"Discover Events")
            
            ForEach(filteredUpcomingEvents) { event in
                UpcomingEventCard(event: event,
                                showRegistrationAlert: $showRegistrationAlert,
                                registeredEventName: $registeredEventName)
            }
        })
    }
}

struct TabScreen: View {
    var title: String = ""
    var tabs: Array<t_key>
    @State var activeTab: String
    
    var body: some View {
        VStack(spacing:0) {
            if title != "" {
                DashboardHeader(text:title)
            }
            
            selectionButtons(activeTab: $activeTab, tabs:t_views.map { $0.name })
            
            if let selectedTab = t_views.first(where: { $0.name == activeTab }) {
                selectedTab.content
            }
        }.ignoresSafeArea(edges: [.top, .bottom])
            .background(secondcolor)
    }
}

#Preview {
    TabScreen(title: "glucoguide community hhhhh", tabs: t_views, activeTab: "feed")
}
