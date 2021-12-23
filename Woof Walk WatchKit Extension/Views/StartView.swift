//
//  ContentView.swift
//  Woof Walk WatchKit Extension
//
//  Created by Michael Adams on 12/20/21.
//

import SwiftUI
import HealthKit

struct StartView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @ObservedObject var userSettings = UserSettings()
    @ObservedObject var walks = Walks()
    
    var workoutType: HKWorkoutActivityType = .walking
    
    var body: some View {
        ScrollView {
            LazyVStack {
                VStack {
                    Text("\(userSettings.dogName)'s walks:")
                        .fontWeight(.thin)
                    Text("\(Int(walks.todaysWalks)) minutes")
                        .fontWeight(.semibold)
                        .padding()
                    
                }
                NavigationLink("Begin Walk", destination: SessionPagingView(), tag: workoutType, selection: $workoutManager.selectedWorkout)
                    .padding()
                NavigationLink("Settings", destination: SettingsView())
                    .padding()
                
            }
            .padding([.bottom, .trailing])
            .onAppear {
                workoutManager.requestAuthorization()
            }
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
        default:
            return ""
        }
    }
}
