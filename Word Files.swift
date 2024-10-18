//
//  Word Files.swift
//  ML Test
//
//  Created by Minseo Kim on 9/20/24.
//

import SwiftUI



struct resultspage: View {
    var result: Double
    var explanation: String
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            maincolor
                .ignoresSafeArea()
            VStack{
                Text("You have " + String(result) + " risk of diabetes")
                Text(explanation)
            }
            VStack(){
                HStack() {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Manually go back
                    }) {
                        Image("Home")
                    }.padding()
                    Spacer()
                }
                Spacer()
            }
        }.navigationBarBackButtonHidden(true)
        
    }
}

let questionsdict = [
    //["DIABETE3", "Do you have diabetes?", ["Yes", "Pregnant", "No", "No"]] ,
    ["GENHLTH", "How would you rate your general health?", ["Excellent", "Very Good", "Good", "Fair", "Poor"]] ,
    ["PERSDOC2", "Do you have one or multiple healthcare professionals you see regularly?", ["Yes, only one", "More than one", "No"]] ,
    ["CHECKUP1", "How long has it been since your last routine check-up?", ["Within the past year (anytime less than 12 months ago)", "Within past 2 years (1 year but less than 2 years ago)", "Within past 5 years (2 years but less than 5 years ago)", "5 or more years ago"]] ,
    ["BPHIGH4", "Have you ever been told by a healthcare professional that you have high blood pressure?", ["Yes", "Yes, but female told only during pregnancy", "No", "Told borderline high or pre-hypertensive"]] ,
    ["BLOODCHO", "Have you ever had your blood cholesterol checked?", ["No", "Yes"]] ,
    ["TOLDHI2", "Have you ever been told by a healthcare professional that your blood cholesterol is high?", ["No", "Yes"]] ,
    ["CVDINFR4", "Have you ever been diagnosed with a heart attack (myocardial infarction)?", ["No", "Yes"]] ,
    ["CHCKIDNY", "Have you ever been told by a healthcare professional that you have kidney disease?", ["No", "Yes"]] ,
    ["SEX", "What is your sex?", ["Male", "Female"]] ,
    ["EMPLOY1", "What is your current employment status?", ["Employed for wages", "Self-employed", "Out of work for 1 year or more", "Out of work for less than 1 year", "A homemaker", "A student", "Retired", "Unable to work"]] ,
    ["INCOME2", "What is your annual household income from all sources?", ["Less than $10,000", "Less than $15,000 ($10,000 to less than $15,000)", "Less than $20,000", "Less than $25,000", "Less than $35,000", "Less than $50,000", "Less than $75,000", "$75,000 or more"]] ,
    ["_PRACE1", "What is your preferred race?", ["White", "Black", "Native American", "Asian", "PI"]] ,
    ["FRUITJU1", "In the past month, how many times per day, week, or month did you drink 100% pure fruit juices?", []] ,
    ["_AGEG5YR", "What is your age group? (in 5-year increments)", ["Age 18 to 24", "Age 25 to 29", "Age 30 to 34", "Age 35 to 39", "Age 40 to 44", "Age 45 to 49", "Age 50 to 54", "Age 55 to 59", "Age 60 to 64", "Age 65 to 69", "Age 70 to 74", "Age 75 to 79", "Age 80 or older"]] ,
    ["HTM4", "What is your height in meters?", []] ,
    ["WTKG3", "What is your weight in kilograms?", []] ,
    ["_RFBMI5", "Are you considered overweight or obese based on your BMI?", ["No", "Yes"]] ,
    ["DROCDY3_", "On average, how many drink occasions do you have per day?", []] ,
    ["_RFBING5", "In the past 30 days, have you engaged in binge drinking? (4 or more drinks for women, 5 or more for men on a single occasion)", ["No", "Yes"]]
]
