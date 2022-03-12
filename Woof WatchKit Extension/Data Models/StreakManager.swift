//
//  StreakManager.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 3/12/22.
//

import Foundation
import SwiftUI
import Combine

public func checkForStreak() -> Int {
    let lastGoalReached = UserDefaults.standard.string(forKey: "lastGoalReached")
    
    guard let lastGoalReached = lastGoalReached else {
        UserDefaults.standard.set(0, forKey: "streak")
        UserDefaults.standard.set(String(describing: Date()), forKey: "lastGoalReached")
        return 1
    }
    
    let format = DateFormatter()
    format.dateFormat = "YYYY-MM-DD"
    
    guard let lastGoalReachedDate = format.date(from: lastGoalReached) else {
        return 0
    }
    
    guard let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: lastGoalReachedDate) else {
        return 0
    }
    
    if Calendar.current.isDateInToday(lastGoalReachedDate) {
        return UserDefaults.standard.integer(forKey: "streak")
    } else if Calendar.current.isDateInToday(modifiedDate) {
        var streak = UserDefaults.standard.integer(forKey: "streak")
        streak += 1
        UserDefaults.standard.set(streak, forKey: "streak")
        UserDefaults.standard.set(false, forKey: "streakRewarded")
        return streak
    } else {
        UserDefaults.standard.set(1, forKey: "streak")
        return 1
    }

}
