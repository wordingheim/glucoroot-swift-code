//
//  Untitled.swift
//  ML Test
//
//  Created by Minseo Kim on 9/16/24.
//

import SwiftUI


struct BTNs: View {
    var text: String
    var index: Int
    var ontap: (Int) -> Void
    var isChecked: Bool
    
    
    var body: some View {
        Button(action: {
            ontap(index)
        }) {
            Text(text)
                .foregroundColor(isChecked ? Color.white : maincolor)
                .frame(maxWidth: .infinity)
                .padding(5)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(maincolor, lineWidth: isChecked ? 4 : 1)
                        .fill(isChecked ? maincolor : Color.clear)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 5)

    }
    
}

struct PageV: View{
    var question: String
    var answers: [String]
    
    var pagenumber: Int
    var totalnumber: Int
    var leftfunc: () -> Void
    var rightfunc: () -> Void
    @State var numberString = ""
    
    @Binding var selectionInd: Float
    //@EnvironmentObject var globalSelections: GlobalSelections
    
    var body: some View {
        
        ZStack{
            secondcolor
                .ignoresSafeArea()
            VStack{
                Text("Diabetes Risk Assessment")
                    .font(.title2)
                    .bold()
                    .foregroundColor(maincolor)
                    .padding()

                Text("Question \(self.pagenumber) of \(self.totalnumber)")
                
                Text(question)
                HStack{
                    VStack{
                        if answers.isEmpty {
                            TextField("Enter number", text: $numberString)
                                .padding()
                                .onChange(of: numberString) { oldValue, newValue in
                                    numberString = newValue.filter { $0.isNumber }
                                    if let intValue = Float(numberString) {
                                        self.selectionInd = intValue
                                        //globalSelections.selections[pagenumber-1] = intValue
                                    } else {
                                        self.selectionInd = -1
                                        //globalSelections.selections[pagenumber-1] = -1
                                    }
                                }
                                .border(Color.gray)
                        } else {
                            ForEach(answers.indices, id: \.self) { index in
                                BTNs(
                                    text: answers[index],
                                    index: index,
                                    ontap: { tappedId in
                                        selectButton(index: index)
                                    },
                                    //isChecked: globalSelections.selections[pagenumber-1] == Float(index)
                                    isChecked: selectionInd == Float(index)
                                )
                            }
                        }
                        
                    }.padding()
                    Spacer()
                }
                
                HStack{
                    Button(action: {
                        self.leftfunc()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                            Text("Previous")
                                .foregroundColor(.white)
                        }
                    }
                    .padding(14)
                    .background(
                        Rectangle()
                            .fill(maincolor)
                            .opacity((self.pagenumber == 1) ? 0.4 : 1)
                    )
                    .padding(6)
                    .disabled(self.pagenumber == 1)
                    
                    Spacer()
                    
                    Button(action: {
                        self.rightfunc()
                    }) {
                        HStack {
                            Text((self.pagenumber != self.totalnumber) ? "Next" : "Finish")
                                .foregroundColor(.white)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                        }
                    }
                    .padding(14)
                    .background(
                        Rectangle()
                            .fill(maincolor)
                            //.opacity((globalSelections.selections[pagenumber-1] == -1) ? 0.4 : 1)
                        )
                    .padding(6)
                    //.disabled(globalSelections.selections[pagenumber-1] == -1)
                    
                }
            }
            .padding(5) // Add padding inside the box
            .background(
                Rectangle() // Use a RoundedRectangle for the box
                    .fill(Color.white) // White box
                    .shadow(radius: 5) // Optional: Add a shadow to the box
            )
            .padding()
            
        }
        
        
        
    }
    
    func selectButton(index: Int) {
        self.selectionInd = Float(index)
        //globalSelections.selections[pagenumber-1] = Float(index)
    }
    
}



struct PageVTestWrapper: View {
    @State private var temp: Float = -1.0
    
    var body: some View {
        PageV(
            question: "Sigma 1",
            answers: ["sigm1", "sigm2"],
            pagenumber: 4,
            totalnumber: 20,
            leftfunc: {},
            rightfunc: {},
            selectionInd: $temp
        )
    }
}

#Preview {
    PageVTestWrapper()
}
