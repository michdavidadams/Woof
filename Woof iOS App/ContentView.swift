//
//  ContentView.swift
//  Woof iOS App
//
//  Created by Michael Adams on 6/29/22.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var healthStore: HealthStore
    @AppStorage("name", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var name: String = "Your Dog"
    @State var recentWorkout: HKWorkout?
    
    var body: some View {
        List {
            Section {
                DogStatsView()
                    .padding()
            } header: {
                Text("\(name)'s Activity")
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
            }
            .headerProminence(.increased)
            
            Section {
                if recentWorkout != nil {
                    Text("\(recentWorkout?.startDate ?? Date.now)")
                } else {
                    Text("No workouts.")
                }
            } header: {
                HStack {
                Text("Workouts")
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    
                    Spacer()
                    
                    NavigationLink(destination: AllWorkoutsView(allWorkouts: healthStore.allWorkouts), label: {
                        Text("More")
                    })
                }
            }
            
        }
        .listStyle(.insetGrouped)
        .listRowBackground(Color.gray.opacity(0.2))
        .refreshable {
            healthStore.getRecentExercises()
            if healthStore.allWorkouts.first != nil {
                recentWorkout = healthStore.allWorkouts.last
            }
        }
        
        .navigationTitle("Woof")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            healthStore.requestAuthorization()
            healthStore.getRecentExercises()
            if healthStore.allWorkouts.first != nil {
                recentWorkout = healthStore.allWorkouts.last
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
