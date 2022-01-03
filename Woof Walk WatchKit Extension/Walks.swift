//
//  Walks.swift
//  Woof Walk WatchKit Extension
//
//  Created by Michael Adams on 12/23/21.
//

import Foundation
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
}
