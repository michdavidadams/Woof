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
                VStack(alignment: .leading) {
                    Text("\(userSettings.dogName) 🐶")
                        .font(.title)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .padding()
                    NavigationLink("Begin Walk", destination: SessionPagingView(), tag: workoutType, selection: $workoutManager.selectedWorkout)
                        .padding()
                    Divider()
                    Text("exercise")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                    Text("\(Int(walks.todaysWalks))/\(userSettings.exerciseGoal) MIN")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.green)
                        .multilineTextAlignment(.leading)
                    Divider()
                    Text("streak")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                    Text("\(Int(walks.streak)) DAYS")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.yellow)
                        .multilineTextAlignment(.leading)
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView().environmentObject(WorkoutManager())
            .environmentObject(UserSettings())
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
        default:
            return ""
        }
    }
}
