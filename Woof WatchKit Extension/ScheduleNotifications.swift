//
//  ScheduleNotifications.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 8/6/22.
//

import UserNotifications
import SwiftUI

func scheduleNotifications() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
        if success {
            print("Notification authorization successful")
        } else if let error = error {
            print(error.localizedDescription)
        }
    }
    
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    let content = UNMutableNotificationContent()
    
    // Dog stats
    @AppStorage("goal", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var goal: Int?
    @AppStorage("name", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var name: String?
    @AppStorage("todaysExercise", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var todaysExercise: Int?
    
    // Notification settings
    @AppStorage("notificationFrequency", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var notificationFrequency: Int? // In hours
    
    content.title = "\(name ?? "Your Dog")'s Exercise"
    content.body = "\(todaysExercise ?? 0)/\(goal ?? 30) minutes"
    content.sound = UNNotificationSound.default
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(notificationFrequency ?? 4 * 120), repeats: true)
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request)
    
    print("Notification scheduled")
}
