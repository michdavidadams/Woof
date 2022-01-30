//
//  WoofApp.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/20/21.
//

import SwiftUI

@main
struct WoofApp: App {
    @StateObject private var workoutManager = WorkoutManager()
    @StateObject var walks = Walks()
    @StateObject var userSettings = UserSettings()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
            }
            .sheet(isPresented: $workoutManager.showingSummaryView) {
                SummaryView()
            }
            .environmentObject(workoutManager)
            .environmentObject(walks)
            .environmentObject(userSettings)
        }
    }
}
