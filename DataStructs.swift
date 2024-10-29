//
//  DataStructs.swift
//  ML Test
//
//  Created by Minseo Kim on 10/28/24.
//
import SwiftUI

class UserData: ObservableObject {
    @Published var userInfo: [String: String] = [
        "name": "",
        "user": "",
        "password": "",
        "email": "",
        "phone": ""
    ]
}
