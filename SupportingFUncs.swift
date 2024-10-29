//
//  SupportingFUncs.swift
//  ML Test
//
//  Created by Minseo Kim on 10/28/24.
//

import SwiftUI

func doTimer(action:@escaping () -> Void, time: Int) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(time)) {
        withAnimation {
            action()
        }
    }
}

extension URLRequest {
    init(url: URL, method: String, headers: [String: String] = [:], body: [String: Any]? = nil) throws {
        self.init(url: url)
        self.httpMethod = method
        
        // Set headers
        for (key, value) in headers {
            self.addValue(value, forHTTPHeaderField: key)
        }
        
        // Set JSON body if provided
        if let body = body {
            self.httpBody = try JSONSerialization.data(withJSONObject: body)
            self.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
}
