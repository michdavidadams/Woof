//
//  Walks.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/23/21.
//

import Foundation
import Combine
import SwiftUI

class Walks: ObservableObject {
    
    @Published var todaysWalks: Double = 0
    @Published var lastWalk: Date = Date.yesterday
    @Published var streak: Int = 0
    
    init() {
        self.todaysWalks = UserDefaults.standard.object(forKey: "todaysWalks") as? Double ?? 0.0
        self.streak = UserDefaults.standard.object(forKey: "streak") as? Int ?? 0
        self.lastWalk = UserDefaults.standard.object(forKey: "lastWalk") as? Date ?? Date()

    }
    
    func getTodaysWalks() {
        if Calendar.current.isDateInToday(lastWalk) == false {
            todaysWalks = 0
        }
    }
    
    func updateWalks(minutes: Double, lastWalk: Date) {
        todaysWalks += minutes
        self.lastWalk = lastWalk
    }
    
    func updateStreak() {
        if (todaysStreak.timeIntervalSinceNow < 0) && (todaysWalks >= 30) {
            streak += 1
            todaysStreak = Date()
        }
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
