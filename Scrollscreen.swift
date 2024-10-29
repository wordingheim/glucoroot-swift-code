//
//  Scrollscreen.swift
//  ML Test
//
//  Created by Minseo Kim on 10/26/24.
//
import SwiftUI

struct ScrollScreen<Content: View>: View {
    var title: String = ""
    var content: Content
    var dir: Axis.Set = .vertical
    let pdg: Edge.Set = .horizontal
    
    var body: some View {
        VStack(spacing:0) {
            if title != "" {
                DashboardHeader(text:title)
            }
            
            
            ScrollView(dir, showsIndicators: false){
                
                content
                    .ignoresSafeArea(edges: .bottom)
            }
            .padding(8)
            //.padding(dir == .horizontal ? [.vertical] : [.horizontal], 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }.ignoresSafeArea(edges: [.top, .bottom])
            .background(secondcolor)
    }
}

#Preview {
    ScrollScreen(title: "Diabetes Dashboard", content: DHD())
}
