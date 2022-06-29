//
//  SettingsView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/22/21.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("name", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var name: String = "Your Dog"
    @AppStorage("goal", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var goal: Int = 30
    
    var body: some View {
            ScrollView {
                LazyVStack {
                    
                    VStack {
                        Text("DOG NAME")
                        TextField("Dog name", text: $name)
                    }
                    .padding()
                    
                    VStack {
                        Text("EXERCISE GOAL")
                        HStack {
                            Button("-") {
                                goal -= 5
                            }
                            Text("\(goal)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .lineLimit(1)
                                .padding(.horizontal)
                            Button("+") {
                                goal += 5
                            }
                        }
                    }
                    .padding()
                    
                    VStack {
                        Button("Save") {
                            name = name
                            goal = goal
                        }
                    }
                    .padding()
                }
            }
        
        .navigationTitle(Text("Settings"))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
