//
//  StreakModel.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 3/15/22.
//

import Foundation
import SwiftUI
import Combine

class StreakModel: ObservableObject {
    
    @Published var currentStreak: Int {
        didSet {
            UserDefaults.standard.set(currentStreak, forKey: "currentStreak")
        }
    }
    
    @Published var dateAwarded: Date {
        didSet {
            UserDefaults.standard.set(Date(), forKey: "dateAwarded")
        }
    }
    
    init() {
        UserDefaults.standard.register(defaults: [
            "streak.currentStreak" : 0,
            "streak.dateAwarded" : Date.distantPast
        ])
        currentStreak = UserDefaults.standard.integer(forKey: "streak.currentStreak")
        dateAwarded = UserDefaults.standard.object(forKey: "streak.dateAwarded") as? Date ?? Date.distantPast
    }
}

class StreakViewModel: ObservableObject {
    @Published private var streak = StreakModel()
    
    var currentStreak: Int {
        get { streak.currentStreak }
        set { streak.currentStreak = Int(newValue) }
    }
    
    var dateAwarded: Date {
        get { streak.dateAwarded as Date }
        set { streak.dateAwarded = newValue }
    }
}
