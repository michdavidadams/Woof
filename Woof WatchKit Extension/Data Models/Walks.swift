//
//  Walks.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/23/21.
//

import Foundation
import SwiftUI
import Combine

class Walks: ObservableObject {
    
    @Published var todaysWalks: Double {
        didSet {
            UserDefaults.standard.set(todaysWalks, forKey: "todaysWalks")
        }
    }
    @Published var lastWalk: Date {
        didSet {
            UserDefaults.standard.set(lastWalk, forKey: "lastWalk")
        }
    }
    @Published var streak: Int {
        didSet {
            UserDefaults.standard.set(streak, forKey: "streak")
        }
    }
    var todaysStreak: Date {
        didSet {
            UserDefaults.standard.set(todaysStreak, forKey: "todaysStreak")
        }
    }
    
    init() {
        self.todaysWalks = UserDefaults.standard.object(forKey: "todaysWalks") as? Double ?? 0.0
        self.streak = UserDefaults.standard.object(forKey: "streak") as? Int ?? 0
        self.lastWalk = UserDefaults.standard.object(forKey: "lastWalk") as? Date ?? Date()
        self.todaysStreak = UserDefaults.standard.object(forKey: "todaysStreak") as? Date ?? Date.yesterday
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
