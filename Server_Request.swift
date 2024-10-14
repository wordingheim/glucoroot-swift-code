import Foundation

// Function to make the POST request


let prediction_stage2 = [["GENHLTH", 3.0], ["PERSDOC2", 1.0], ["CHECKUP1", 1.0], ["BPHIGH4", 1.0], ["BLOODCHO", 1.0], ["TOLDHI2", 1.0], ["CVDINFR4", 2.0], ["CHCKIDNY", 2.0], ["SEX", 2.0], ["EMPLOY1", 8.0], ["INCOME2", 1.0], ["_PRACE1", 1.0], ["FRUITJU1", 101.0], ["_AGEG5YR", 10.0], ["HTM4", 163.0], ["WTKG3", 9072.0], ["_RFBMI5", 2.0], ["DROCDY3_", 5.397605346934028e-79], ["_RFBING5", 1.0]]


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
let session = URLSession(configuration:URLSessionConfiguration.default)

func calculate(data_entry: [[Any]]) {
    //print(questions)
    //let combined = zip(questions, data_entry).map{[$0.0, $0.1]}
    //print(combined)
    
    
    let shf = data_entry.shuffled()
    let url = URL(string: "http://127.0.0.1:5000/calculate")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    //let rz_array = random_zip.map{[$0.0, $0.1]}
    let predictionDict: [String: Any] = ["prediction": shf]
    //let predictionDict: [String: Any] = ["prediction": combined]
    let jsonData = try? JSONSerialization.data(withJSONObject: predictionDict)
    request.httpBody = jsonData
    
    // Create the URLSession data task
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print("Error:", error?.localizedDescription ?? "Unknown error")
            return
        }
        // Parse the response
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code:", httpResponse.statusCode)
            if httpResponse.statusCode == 401 {
                print("LOGIN ERROR")
            } else if httpResponse.statusCode == 200 {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let score = jsonResponse["score"] as? Double,
                           let probability = jsonResponse["probability"] as? Double,
                           let tLow = jsonResponse["t_low"] as? Double,
                           let tHigh = jsonResponse["t_high"] as? Double,
                           let binScore = jsonResponse["binscore"] as? Double {
                            print("Your raw score is: \(score)")
                            print("Your probability of having diabetes is: \(probability)")
                            print("Your sample group is: \(tLow) - \(tHigh)")
                            print("Your sample probability is: \(binScore)")
                        }
                    }
                } catch {
                    print("Failed to parse response:", error)
                }
            }
        }
    }
    
    // Start the task
    task.resume()
}

func login(user: String, pw: String, completion: @escaping(Bool, Array<String>) -> Void) {
    let url = URL(string: "http://127.0.0.1:5000/login")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let list: [String: Any] = [
        "username": user,
        "password": pw
    ]
    let jsonData = try? JSONSerialization.data(withJSONObject: list)
    request.httpBody = jsonData
        
    // Create a URLSession data task
    let task = session.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error:", error.localizedDescription)
            completion(false, [])
            return
        }
        
        // Check the HTTP status code
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code:", httpResponse.statusCode)
        }
        
        // Check if there"s data returned from the server
        if let data = data {
            do {
                // Parse the JSON response
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response Data:", jsonResponse)
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            let name = jsonResponse["name"] as? String ?? ""
                            let username = jsonResponse["username"] as? String ?? ""
                            let email = jsonResponse["email"] as? String ?? ""
                            completion(true, [name, username, email])
                        } else {
                            completion(false, [])
                        }
                    }
                }
            } catch {
                print("Failed to parse response:", error)
            }
        }
    }
    
    task.resume()

}


func logout(completion: @escaping (Bool) -> Void) {
    let url = URL(string: "http://127.0.0.1:5000/logout")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST" // Use POST method for logout
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error:", error.localizedDescription)
            completion(false) // Return nil on error
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code:", httpResponse.statusCode)
            if httpResponse.statusCode == 200 {
                // Parse the JSON response if needed
                if let data = data {
                    do {
                        // Decode the response
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let message = jsonResponse["message"] as? String {
                            completion(true)
                            print(message)// Return the success message
                        }
                    } catch {
                        print("Failed to parse response:", error)
                        completion(false)
                    }
                } else {
                    completion(false) // Return nil if there"s no data
                }
            } else {
                completion(false) // Return nil for any non-200 status code
            }
        }
    }
    
    task.resume() // Start the network task
}

func addUser(user:String, pw:String, email:String, name:String, completion: @escaping(Bool) -> Void) {
    let url = URL(string: "http://127.0.0.1:5000/add_user")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let list: [String: Any] = [
        "username": user,
        "password": pw,
        "email": email,
        "name": name
    ]
    let jsonData = try? JSONSerialization.data(withJSONObject: list)
    request.httpBody = jsonData
    
    let task = session.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error:", error.localizedDescription)
            completion(false)
            return
        }
        
        // Check the HTTP status code
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code:", httpResponse.statusCode)
            if httpResponse.statusCode == 200 {
                print("success")
                completion(true)
            } else {
                print("error")
                completion(false)
            }
        }
        

    }
    
    // Start the task
    task.resume()
    
}
