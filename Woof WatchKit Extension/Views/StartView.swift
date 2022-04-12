//
//  ContentView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/20/21.
//

import Combine
import SwiftUI
import HealthKit

struct StartView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @AppStorage("dog.name") var name: String?
    @AppStorage("dog.goal") var goal: Int?
    @AppStorage("dog.currentStreak") var currentStreak: Int?
    
    var workoutTypes: [HKWorkoutActivityType] = [.walking, .play]
    
    var body: some View {
        NavigationView {
            List {
                
                DogStatsView()
                    .listRowBackground(Color.black)
                
                NavigationLink("Walk", destination: SessionPagingView(), tag: .walking, selection: $workoutManager.selectedWorkout).padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
                NavigationLink("Play", destination: SessionPagingView(), tag: .play, selection: $workoutManager.selectedWorkout).padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
                NavigationLink("Settings", destination: SettingsView())
                    .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
                
                
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationBarHidden(false)
            .navigationTitle(name ?? "Woof")
            .navigationViewStyle(.automatic)
            .listStyle(.carousel)
        }
        .onAppear {
            workoutManager.requestAuthorization()
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView().environmentObject(WorkoutManager())
    }
}

extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }
    
    var name: String {
        switch self {
        case .walking:
            return "Walk"
        case .play:
            return "Play"
        default:
            return ""
        }
    }
}
