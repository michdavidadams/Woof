//
//  Woof_WalkApp.swift
//  Woof Walk WatchKit Extension
//
//  Created by Michael Adams on 12/20/21.
//

import SwiftUI

@main
struct Woof_WalkApp: App {
    @StateObject private var workoutManager = WorkoutManager()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
            }
            .sheet(isPresented: $workoutManager.showingSummaryView) {
                SummaryView()
            }
            .environmentObject(workoutManager)
        }
    }
}
