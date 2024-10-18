//
//  ContentView.swift
//  ML Test
//
//  Created by Minseo Kim on 9/16/24.
//

import SwiftUI



struct Questions: View{
    @State private var selectedtab: Int = 0
    @State var selections: Array<Float> = []
    
    var qst: Array<String>
    var ans: Array<Array<String>>
    var vrb: Array<String>
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var globalSelections: GlobalSelections
    
    //questions: Array<(String, String)>, answers:Array<Array<String>>, 
    init(questionsframe: Array<Array<Any>>, selections: Array<Float>? = nil) {
        self.vrb = questionsframe.map { $0[0] as! String }
        self.ans = questionsframe.map { $0[2] as! Array<String>}
        self.qst = questionsframe.map { $0[1] as! String }
        self._selections = State(initialValue: Array(repeating: -1, count: vrb.count))
    }
    
    var body: some View{
        ZStack{
            secondcolor
                .ignoresSafeArea()
            
            TabView(selection: $selectedtab){
                ForEach(vrb.indices, id: \.self) { index in
                    let lft = (index==0) ? donone : prevpage
                    let rgt = (index+1 != vrb.count) ? nextpage : finish
                    PageV(
                        question: qst[index],
                        answers: ans[index],
                        pagenumber: index+1,
                        totalnumber: vrb.count,
                        leftfunc: lft,
                        rightfunc: rgt,
                        selectionInd: $selections[index]
                    )
                    .tag(index)
                    
                }
                
            }
            .tabViewStyle(PageTabViewStyle())
            .navigationBarBackButtonHidden(true)
            VStack(){
                
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(maincolor)
                        Text("Home")
                            .foregroundColor(maincolor)
                    }.padding()
                    Spacer()
                    
                }
                Spacer()
            }
        }
    }
        
    private func prevpage() -> Void {
        selectedtab -= 1
    }
    private func nextpage() -> Void {
        selectedtab += 1
    }
    private func finish() -> Void {
        print(globalSelections.selections)
        let zippedArray = Array(zip(self.vrb, self.selections)).map { [$0.0, $0.1] }
        print(zippedArray)
        calculate(data_entry: zippedArray) {result in
            switch result {
            case .success(let data):
                print("Your raw score is: \(data["score"] ?? 0)")
                print("Your probability of having diabetes is: \(data["probability"] ?? 0)")
                print("Your sample group is: \(data["tLow"] ?? 0) - \(data["tHigh"] ?? 0)")
                print("Your sample probability is: \(data["binScore"] ?? 0)")
                
            case .failure(let error):
                print("Error:", error.localizedDescription)
            }
        }
        
        globalSelections.reset()
        
        presentationMode.wrappedValue.dismiss()
    }
    private func donone() -> Void {
        
    }
}
//ALL TESTING VARS
var questionssample = ["question 1", "question 2", "question 3", "question 4"]
var answerssample = [
    ["ans1", "ans2", "ans3", "ans4"],
    ["ans1", "ans2", "ans3"],
    ["ans1", "ans2", "ans3", "ans4"],
    ["ans1", "ans2", "ans3", "ans4"]
]
var q_v = [
    ("How would you rate your general health?", "GENHLTH"),
    ("In the past 30 days, for how many days was your physical health not good?", "PHYSHLTH"),
    ("In the past 30 days, for how many days was your mental health not good?", "MENTHLTH"),
    ("Do you have any form of health insurance coverage?", "HLTHPLN1")
]
var result = 0.89
var explanation = "This is the explanation. We used some things to calculate this. To avoid diabetes, we recommend these sorts of things."

var userpw = [
    "User1" : "Pw1"
]

