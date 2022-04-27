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
    
    @Published var currentStreak: Int {
        didSet {
            UserDefaults.standard.set(currentStreak, forKey: "currentStreak")
        }
    }
    
    @Published var todaysExercise: Int {
        didSet {
            UserDefaults.standard.set(currentStreak, forKey: "currentStreak")
        }
    }
    
    @Published var awardedDate: Double {
        didSet {
            UserDefaults.standard.set(awardedDate, forKey: "awardedDate")
        }
    }
    
    @Published var lastExerciseDate: Double {
        didSet {
            UserDefaults.standard.set(lastExerciseDate, forKey: "lastExerciseDate")
        }
    }
    
    init() {
        UserDefaults.standard.register(defaults: [
            "dog.name" : "Woof",
            "dog.goal" : 30,
            "dog.currentStreak" : 0,
            "dog.todaysExercise" : 0,
            "dog.awardedDate" : Date.distantPast.timeIntervalSince1970,
            "dog.lastExerciseDate" : Date.distantPast.timeIntervalSince1970

        ])
        name = UserDefaults.standard.string(forKey: "dog.name") ?? "Woof"
        goal = UserDefaults.standard.integer(forKey: "dog.goal")
        currentStreak = UserDefaults.standard.integer(forKey: "dog.currentStreak")
        todaysExercise = UserDefaults.standard.integer(forKey: "dog.todaysExercise")
        awardedDate = UserDefaults.standard.double(forKey: "dog.awardedDate")
        lastExerciseDate = UserDefaults.standard.double(forKey: "dog.lastExerciseDate")
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
    
    var currentStreak: Int {
        get { dog.currentStreak }
        set { dog.currentStreak = Int(newValue)}
    }
    
    var todaysExercise: Int {
        get { dog.todaysExercise }
        set { dog.todaysExercise = Int(newValue)}
    }
    
    var awardedDate: Double {
        get { dog.awardedDate }
        set { dog.awardedDate = newValue }
    }
    
    var lastExerciseDate: Double {
        get { dog.lastExerciseDate }
        set { dog.lastExerciseDate = newValue }
    }
    
}
