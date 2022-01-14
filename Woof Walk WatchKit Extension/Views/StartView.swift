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
    @EnvironmentObject var locationManager: LocationManager
    @ObservedObject var userSettings = UserSettings()
    @ObservedObject var walks = Walks()
    var workoutTypes: [HKWorkoutActivityType] = [.walking, .play]
    
    
    var body: some View {
        ScrollView {
            LazyVStack {
                VStack(alignment: .leading) {

                    VStack {
                    NavigationLink("Walk", destination: SessionPagingView(), tag: .walking, selection: $workoutManager.selectedWorkout)
                    NavigationLink("Play", destination: SessionPagingView(), tag: .play, selection: $workoutManager.selectedWorkout)
                    }
                    .padding()
                    Divider()
                    Text("\(userSettings.dogName) 🐶")
                        .font(.title)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .padding()
                    VStack(alignment: .leading) {
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
                    }
                    VStack(alignment: .leading) {
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
                    }
                    Divider()
                }
//                NavigationLink("Badges", destination: BadgesView())
//                    .padding()
//                Divider()
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
            .environmentObject(LocationManager())
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
        case .play:
            return "Play"
        default:
            return ""
        }
    }
}
