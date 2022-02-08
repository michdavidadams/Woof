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
    @EnvironmentObject var walks: Walks
    
    var workoutTypes: [HKWorkoutActivityType] = [.walking, .play]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                VStack(alignment: .leading) {
                    VStack {
                            Text("Workouts")
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .padding()
                        
                        NavigationLink("Walk", destination: SessionPagingView(), tag: .walking, selection: $workoutManager.selectedWorkout)
                        NavigationLink("Play", destination: SessionPagingView(), tag: .play, selection: $workoutManager.selectedWorkout)
                    }
                    .padding()
                    Divider()
                    DogStatsView()
                    Divider()
                }
                
                NavigationLink("Settings", destination: SettingsView())
                    .padding()
                
            }
            .padding([.bottom, .trailing])
            .onAppear {
                workoutManager.requestAuthorization()
                walks.getTodaysWalks()
            }
        }
        .navigationBarTitle("Woof")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView().environmentObject(WorkoutManager())
            .environmentObject(Walks())
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
