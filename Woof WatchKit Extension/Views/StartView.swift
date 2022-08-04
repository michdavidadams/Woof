//
//  ContentView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/20/21.
//

import SwiftUI
import HealthKit

struct StartView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var workoutTypes: [HKWorkoutActivityType] = [.walking, .play]
    
    var body: some View {
        NavigationView {
            
            List {
                
                DogStatsView()
                    .listRowBackground(Color.black)
                
                NavigationLink(destination: SessionPagingView(), tag: .walking, selection: $workoutManager.selectedWorkout) {
                    HStack {
                        Text("Walk")
                            .fontWeight(.semibold)
                        Spacer()
                        Image("pawprint")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                    }
                }
                .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                NavigationLink(destination: SessionPagingView(), tag: .play, selection: $workoutManager.selectedWorkout) {
                    HStack {
                        Text("Play")
                            .fontWeight(.semibold)
                        Spacer()
                        Image("tennisball")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                    }
                }
                .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                NavigationLink(destination: SettingsView()) {
                    HStack {
                        Text("Settings")
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "gearshape.fill")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                    }
                }
                .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                
            }
            .navigationTitle("Woof")
            .navigationBarHidden(false)
            .navigationViewStyle(.automatic)
            .listStyle(.carousel)
        }
        .onAppear {
            workoutManager.requestAuthorization()
            scheduleNotifications()
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
    
    var image: Image {
        switch self {
        case .walking:
            return Image("pawprint")
        case .play:
            return Image("tennisball")
        default:
            return Image("pawprint")
        }
    }
}
