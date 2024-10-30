//
//  SmallStructs.swift
//  ML Test
//
//  Created by Minseo Kim on 10/26/24.
//

import SwiftUI

struct Header: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .foregroundColor(maincolor)
            .fontWeight(.bold)
    }
}

struct DashboardHeader: View {
    var text: String
    var body: some View {
        VStack {
            Spacer().frame(height:60)
            Text(text)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(height:60)
                
        }.frame(maxWidth:.infinity)
            .padding(0)
            .background(maincolor)
    }
}

struct SmallCard<Content: View>: View {
    var content: Content
    var color: Color = Color.white
    var header: String = ""
    var height: Int = -1
    var foreground: Color = Color.black
    var body: some View {
        VStack {
            if !header.isEmpty { 
                Text(header)
                    .font(.headline)
                    .foregroundColor(textcolor)
            }
            content
        }
            .padding()
            .foregroundStyle(foreground)
            .frame(height: height > 0 ? CGFloat(height) : nil)
            .frame(maxWidth:.infinity)
            .background(color)
            .cornerRadius(8)
            .shadow(radius: 4)
    }
}

struct smallInfoBox: View {
    var text: String
    var color: Color = Color.white
    var textcolor: Color = Color.black
    var opacity: Float = 1
    var body: some View {
        Text(text)
            .font(.caption)
            .padding(8)
            .background(color)
            .foregroundColor(textcolor)
            .cornerRadius(8)
            .shadow(radius: 4)
    }
}

struct navigationWrapper<Content: View, Destination: View>: View {
    var content: Content
    var dest: Destination
    var body: some View {
        NavigationLink(destination:dest) {
            content
        }
    }
}

struct smallHeader: View {
    var text: String
    var body: some View {
        HStack {
            Text(text)
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
}

struct gridMaker<Content: View>: View {
    var content: Content
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            content
        }
    }
}

struct AddBTN<Destination: View>: View {
    var dest: Destination
    var body: some View {
        NavigationLink(destination: dest) {
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
    }
}

struct selectionButtons: View {
    @Binding var activeTab: String
    var tabs: Array<String>
    var body: some View {
        HStack {
            ForEach(0..<tabs.count) { i in
                Button(action: {
                    activeTab = tabs[i]
                }) {
                    Text(tabs[i])
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(activeTab == tabs[i] ? maincolor : Color.clear)
                        .foregroundColor(activeTab == tabs[i] ? offwhite : .gray)
                        .cornerRadius(4)
                }
            }
        }
        .padding(4)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .shadow(radius: 4)
    }
    
}

struct textBox: View {
    var name: String
    @Binding var text: String
    var body: some View {
        TextField(name, text:$text)
            .autocapitalization(.none)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

struct passwordBox: View {
    var name: String
    @Binding var text: String
    var body: some View {
        SecureField(name, text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

struct numberBox: View {
    var name: String
    @Binding var text: String
    var body: some View {
        TextField(name, text:$text)
            .keyboardType(.numberPad) // Show number pad for input
                .onChange(of: text) {
                    text = text.filter { "0123456789".contains($0) }
                }
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

struct button1: View {
    var text: String
    var color: Color = maincolor
    var height: CGFloat = 36
    var icon: String = ""
    var textcolor: Color = .white
    var body: some View {
        HStack{
            if icon != "" {
                Image(systemName:icon)
            }
            Text(text)
                .fontWeight(.semibold)
        }
            .frame(maxWidth: .infinity)
            .frame(height:height)
            .foregroundColor(textcolor)
            .background(color)
            .cornerRadius(8)
        
    }
}

struct button2<Content: View>: View {
    var content: Content
    var height: CGFloat = 36
    var color: Color = maincolor
    var textcolor: Color = .white
    var body: some View {
        content
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .frame(height:height)
            .foregroundColor(textcolor)
            .background(color)
            .cornerRadius(8)
    }
}

struct buttondetail: View {
    var icon: String = ""
    var text: String
    var imagecolor: Color = .black
    var body: some View {
        HStack {
            if icon != "" {
                Image(systemName: icon)
                    .foregroundColor(imagecolor)
            }
            Text(text)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }.padding(.vertical, 4)
        .frame(maxWidth: .infinity)
    }
}

struct space: View {
    var amt: CGFloat
    var body: some View{
        Spacer()
            .frame(height:amt)
    }
}

struct boldtext: View {
    var text: String
    var color: Color = maincolor
    var body: some View {
        Text(text)
            .fontWeight(.bold)
            .foregroundColor(maincolor)
    }
}

struct smallText: View {
    var text: String
    var color: Color = Color.black
    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundColor(color)
            .multilineTextAlignment(.center)
    }
}

struct bigText: View {
    var text: String
    var color: Color = Color.black
    var body: some View {
        Text("Hello, I'm BetaBit.")
            .font(.headline)
            .fontWeight(.bold)
        
    }
    
}



struct tg: View {
    var body: some View {
        Text("a")
    }
}


struct emptyPlaceHolder: View {
    var body: some View {
        secondcolor
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
struct sample_content: View {
    var body: some View {
        ZStack{
            
            VStack(spacing:0){
                Color.blue
                Color.red
            }
            Text("aaaaaaaa")
                .foregroundStyle(.white)
        }
        
    }
}


struct menuPicker: View {
    var list: Array<String>
    @Binding var picker: String
    @Binding var isToggled: Bool
    var body: some View {
        Menu {
            ForEach(list.indices, id: \.self) { i in
                Button(action: {
                    picker = list[i]
                    isToggled = picker == "Other"
                }) {
                    Text(list[i])
                }
            }
        } label: {
            button2(content:HStack {
                Text(picker)
                Spacer()
                Image(systemName: "chevron.down")
            }.padding(),
                    height:50, color:.white, textcolor:.black)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(maincolor, lineWidth: 1))
        }
    }
}

struct TagButton: View {
    let tag: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            smallInfoBox(text:tag, color:(isSelected ? maincolor : thirdcolor),
                         textcolor:(isSelected ? thirdcolor : textcolor))
        }
    }
}

#Preview {
    /*buttondetail(icon:"bell", text:"aaaa", imagecolor:.blue)
        .padding()*/
    //button1(text:"aaaa")
    //button2(content:"aaaaa")
    //sample_content()
    //button2(content:sample_content())
    @Previewable @State var g = "a"
    let gg = ["aa", "dfdfd", "kujhg"]
    //menuPicker(list:gg, picker: $g)
}

