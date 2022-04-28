//
//  Update Streak.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 4/26/22.
//

import Foundation
import SwiftUI

public func updateStreak(recentExerciseMinutes: TimeInterval) {
    @AppStorage("dog.currentStreak") var currentStreak: Int?
    @AppStorage("dog.goal") var goal: Int?
    @AppStorage("dog.todaysExercise") var todaysExercise: Int?
    @AppStorage("dog.awardedDate") var awardedDate: Double? // Date stored as TimeInterval since 1970
    @AppStorage("dog.lastExerciseDate") var lastExerciseDate: Double?   // Date stored as TimeInterval since 1970
    
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
    guard awardedDate != nil else {
        awardedDate = Date.distantPast.timeIntervalSince1970
        return
    }
    
    // if streak wasn't awarded yesterday and today, set current streak to 0
    let streakAwardedYesterday = Calendar.current.isDateInYesterday(Date(timeIntervalSince1970: awardedDate ?? Date.distantPast.timeIntervalSince1970))
    let streakAwardedToday = Calendar.current.isDateInYesterday(Date(timeIntervalSince1970: awardedDate ?? Date.distantPast.timeIntervalSince1970))
    if !streakAwardedYesterday && !streakAwardedToday {
        currentStreak = 0
    }
    
    // if last exercise date wasn't today, reset today's exercise to 0
    let didExerciseToday = Calendar.current.isDateInToday(Date(timeIntervalSince1970: lastExerciseDate ?? Date.distantPast.timeIntervalSince1970))
    if !didExerciseToday {
        todaysExercise = 0
    }
    
    // if exercise goal reached, and date awarded isn't today, increase streak and set streak date awarded to today
    if !streakAwardedToday && ((todaysExercise! + Int(recentExerciseMinutes / 60)) >= goal!) {
        currentStreak! += 1
        awardedDate = Date().timeIntervalSince1970
    }
    
    // if just exercised, set date last exercised to today and increase today's exercise minutes
    if recentExerciseMinutes > 0.0 {
        todaysExercise! += Int(recentExerciseMinutes / 60)
        lastExerciseDate = Date().timeIntervalSince1970
    }
    
}
