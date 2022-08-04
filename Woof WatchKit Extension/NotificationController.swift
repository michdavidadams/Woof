//
//  NotificationController.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/20/21.
//

import WatchKit
import SwiftUI
import UserNotifications

class NotificationController: WKUserNotificationHostingController<NotificationView> {
    override var body: NotificationView {
        return NotificationView()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func didReceive(_ notification: UNNotification) {
        // This method is called when a notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        
    }
}

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
    
    @AppStorage("goal", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var goal: Int?
    @AppStorage("name", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var name: String?
    @AppStorage("todaysExercise", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var todaysExercise: Int?
    
    content.title = "\(name ?? "Your Dog")'s Exercise"
    content.body = "\(todaysExercise ?? 0)/\(goal ?? 30) minutes"
    content.sound = UNNotificationSound.default
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request)
    
    print("Notification scheduled")
}
