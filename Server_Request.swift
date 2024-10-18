import Foundation

// Function to make the POST request






let session = URLSession(configuration:URLSessionConfiguration.default)

func calculate(data_entry: [[Any]], completion: @escaping (Result<[String: Double], Error>) -> Void) {
    let shf = data_entry.shuffled()
    let url = URL(string: "http://127.0.0.1:5000/calculate")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let predictionDict: [String: Any] = ["prediction": shf]
    let jsonData = try? JSONSerialization.data(withJSONObject: predictionDict)
    request.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            //print("Error:", error?.localizedDescription ?? "Unknown error")
            completion(.failure(error ?? NSError(domain: "Unknown error", code: -1, userInfo: nil)))
            return
        }
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code:", httpResponse.statusCode)
            if httpResponse.statusCode == 401 {
                print("LOGIN ERROR")
                completion(.failure(NSError(domain: "Login Error", code: 401, userInfo: nil)))
            } else if httpResponse.statusCode == 200 {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let score = jsonResponse["score"] as? Double,
                           let probability = jsonResponse["probability"] as? Double,
                           let tLow = jsonResponse["t_low"] as? Double,
                           let tHigh = jsonResponse["t_high"] as? Double,
                           let binScore = jsonResponse["binscore"] as? Double {
                            let result: [String: Double] = [
                                "score": score,
                                "probability": probability,
                                "tLow": tLow,
                                "tHigh": tHigh,
                                "binScore": binScore
                            ]
                            completion(.success(result))
                        }
                    }
                } catch {
                    //print("Failed to parse response:", error)
                    completion(.failure(error))
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

func addUser(user:String, pw:String, email:String, name:String, phone:String, completion: @escaping(Bool) -> Void) {
    let url = URL(string: "http://127.0.0.1:5000/add_user")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let list: [String: Any] = [
        "username": user,
        "password": pw,
        "email": email,
        "name": name,
        "phone": phone
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
