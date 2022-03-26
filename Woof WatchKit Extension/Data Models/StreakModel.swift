//
//  StreakModel.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 3/25/22.
//

import Foundation
import SwiftUI

class Streak: ObservableObject {
    @Published var current = 0
    var dateAwarded = Date.distantPast
    @Published var todaysExercise = 0.0
    var dateLastExercised = Date.distantPast
    @AppStorage("dog.goal") var goal: Int?
    
    func updateStreak(exerciseMinutes: Double) {
        guard let goal = goal else { return }

        todaysExercise += exerciseMinutes
        if !Calendar.current.isDateInToday(dateAwarded) && todaysExercise >= Double(goal) {
            current += 1
            dateAwarded = Date.now
        }
        if !Calendar.current.isDateInYesterday(dateLastExercised) && !Calendar.current.isDateInToday(dateLastExercised) {
            current = 0
        }
        if !Calendar.current.isDateIn
    }
    
}
