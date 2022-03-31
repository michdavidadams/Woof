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
    
    var workoutTypes: [HKWorkoutActivityType] = [.walking, .play]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    VStack(alignment: .leading) {
                        VStack {
                            HStack {
                                NavigationLink("Walk", destination: SessionPagingView(), tag: .walking, selection: $workoutManager.selectedWorkout)
                                NavigationLink("Play", destination: SessionPagingView(), tag: .play, selection: $workoutManager.selectedWorkout)
                            }
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
                }
            }
        }
        .navigationTitle(Text("Woof"))
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
