//
//  WoofApp.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/20/21.
//

import SwiftUI

@main
struct WoofApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var workoutManager = WorkoutManager()
    @StateObject var dog = DogViewModel()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
            }
            .sheet(isPresented: $workoutManager.showingSummaryView) {
                SummaryView()
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(workoutManager)
        }
        
    }
}
