//
//  Update Streak.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 4/26/22.
//

import Foundation
import SwiftUI

// recent exercise minutes Date().timeIntervalSince(self.builder?.startDate ?? Date.now)
public func updateStreak(recentExerciseMinutes: TimeInterval) {
    @AppStorage("dog.currentStreak") var currentStreak: Int?
    @AppStorage("dog.goal") var goal: Int?
    @AppStorage("dog.todaysExercise") var todaysExercise: Int?
    @AppStorage("dog.lastExerciseDate") var lastExerciseDate: Double?
    @AppStorage("dog.dateAwarded") var dateAwarded: Bool?
    let didExerciseToday = Calendar.current.isDateInToday(Date(timeIntervalSince1970: lastExerciseDate ?? Date.distantPast.timeIntervalSince1970))
    let didExerciseYesterday = Calendar.current.isDateInYesterday(Date(timeIntervalSince1970: lastExerciseDate ?? Date.distantPast.timeIntervalSince1970))
    
    guard todaysExercise != nil else {
        todaysExercise = 0
        return
    }
    guard goal != nil else {
        goal = 30
        return
    }
    guard currentStreak != nil else {
        currentStreak = 0
        return
    }
    guard lastExerciseDate != nil else {
        lastExerciseDate = Date.distantPast.timeIntervalSince1970
        return
    }
    guard dateAwarded != nil else {
        dateAwarded = false
        return
    }
    
    // if exercised yesterday but didn't meet goal, reset current streak
    if didExerciseYesterday && (todaysExercise! < goal!) {
        currentStreak = 0
    }
    
    // if last exercise date not today, reset today's exercise to 0
    if !didExerciseToday {
        todaysExercise = 0
        dateAwarded = false
        // If exercise date not yesterday or today, reset current streak
        if !didExerciseYesterday {
            currentStreak = 0
        }
    }
    
    // if today's exercise less than goal, and total is more than goal, add 1 to current streak
    let total = Int(recentExerciseMinutes / 60)
    if ((todaysExercise! + total) >= goal!) && !(dateAwarded!) {
        currentStreak! += 1
        dateAwarded = true
    }
    
    // if didn't exercise, don't add date to lastExerciseDate
    if recentExerciseMinutes != 0.0 {
        todaysExercise! += Int(recentExerciseMinutes / 60)
        lastExerciseDate = Date.now.timeIntervalSince1970
    }
    
    print("Today's Exercise: \(todaysExercise!), didExerciseToday: \(didExerciseToday), didExerciseYesterday: \(didExerciseYesterday), Current Streak: \(currentStreak!)")
    
}
