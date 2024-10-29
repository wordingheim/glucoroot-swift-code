//
//  Centerscreen.swift
//  ML Test
//
//  Created by Minseo Kim on 10/26/24.
//

//
//  Untitled.swift
//  ML Test
//
//  Created by Minseo Kim on 10/26/24.
import SwiftUI

struct CenterScreen<Content: View>: View {
    var header: String = "Page Title"
    let content: Content
    
    
    init(header: String, content:Content) {
        self.content = content
        self.header = header
    }


    init() where Content == Text {
        self.content = Text("No Content")
    }
    
    var body: some View {
        ZStack {
            secondcolor
                .ignoresSafeArea()
           
            VStack {
                Header(text:header)
                Spacer().frame(height:10)
                
                content
            }
            
            .padding(.vertical, 40)
            .padding(.horizontal, 20)// Add padding inside the box
            .frame(minHeight:200)
            .frame(maxWidth:.infinity)
            .background(
                Rectangle()
                    .fill(offwhite)
                    .cornerRadius(8)// White box
                    .shadow(radius:4)
            )
            .padding(.horizontal)
            
        }
    }
    
}

#Preview {
    let g = Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
        .foregroundStyle(.blue)
    CenterScreen(header:"hello", content:g)
}
