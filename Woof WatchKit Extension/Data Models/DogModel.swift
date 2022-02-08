//
//  UserSettings.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/23/21.
//

import Foundation
import SwiftUI
import Combine

class DogModel: ObservableObject {
    
    @Published var name: String {
        didSet {
            UserDefaults.standard.set(name, forKey: "name")
        }
    }
    
    @Published var goal: Int {
        didSet {
            UserDefaults.standard.set(goal, forKey: "goal")
        }
    }
    
    init() {
        UserDefaults.standard.register(defaults: [
            "dog.name" : "Dog",
            "dog.goal" : 30
        ])
        name = UserDefaults.standard.string(forKey: "dog.name") ?? "Dog"
        goal = UserDefaults.standard.integer(forKey: "dog.goal")
    }
}

class DogViewModel: ObservableObject {
    @Published private var dog = DogModel()
    
    var name: String {
        get { String(dog.name) }
        set { dog.name = newValue }
    }
    
    var goal: Int {
        get { dog.goal }
        set { dog.goal = Int(newValue)}
    }
}
