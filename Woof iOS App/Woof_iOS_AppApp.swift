//
//  Woof_iOS_AppApp.swift
//  Woof iOS App
//
//  Created by Michael Adams on 6/29/22.
//

import SwiftUI

@main
struct Woof_iOS_AppApp: App {
    let healthStore = HealthStore()
    
    var body: some Scene {
        WindowGroup {
                NavigationView {
                    ContentView()
                }
                .preferredColorScheme(.dark)
                .environmentObject(healthStore)
        }
    }
}
