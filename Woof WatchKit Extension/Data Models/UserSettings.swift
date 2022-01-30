//
//  UserSettings.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/23/21.
//

import Foundation
import SwiftUI
import Combine

class UserSettings: ObservableObject {
    
    @Published var dogName: String {
        didSet {
            UserDefaults.standard.set(dogName, forKey: "dogName")
        }
    }
    
    @Published var exerciseGoal: Int {
        didSet {
            UserDefaults.standard.set(exerciseGoal, forKey: "exerciseGoal")
        }
    }
    
    init() {
        self.dogName = UserDefaults.standard.object(forKey: "dogName") as? String ?? "Dog"
        self.exerciseGoal = UserDefaults.standard.object(forKey: "exerciseGoal") as? Int ?? 30
    }
}
