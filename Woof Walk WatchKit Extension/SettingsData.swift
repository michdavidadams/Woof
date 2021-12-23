//
//  SettingsData.swift
//  Woof Walk WatchKit Extension
//
//  Created by Michael Adams on 12/22/21.
//

import Foundation

class Dog: ObservableObject {
    @Published var name: String = "Scooby"
    @Published var exerciseGoal: Int = 30
    @Published var todaysWalks: Int = 0
    
    func currentProgress() -> Double {
        return Double(todaysWalks / exerciseGoal)
    }
}
