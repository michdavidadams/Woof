//
//  ContentView.swift
//  Woof iOS App
//
//  Created by Michael Adams on 6/29/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var healthStore: HealthStore
    @AppStorage("name", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var name: String = "Your Dog"
    
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
            
            
            
            
        }
        .listStyle(.insetGrouped)
        .listRowBackground(Color.gray.opacity(0.2))
        
        .navigationTitle("Woof")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            healthStore.requestAuthorization()
            
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
