//
//  SettingsView.swift
//  Woof iOS App
//
//  Created by Michael Adams on 7/17/22.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("name", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var name: String = "Your Dog"
    @AppStorage("goal", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var goal: Int = 30
    
    var body: some View {
            List {
                
                Section(content: {
                    TextField("Dog name", text: $name)
                }, header: {
                    Text("Dog name")
                })
                
                Section(content: {
                    HStack {
                        Button(action: {
                            goal -= 5
                        }) {
                            Image(systemName: "minus.circle.fill")
                        }
                        Text("\(goal)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .padding(.horizontal)
                        Button(action: {
                            goal += 5
                        }) {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                }, header: {
                    Text("Exercise Goal")
                })
                
                    Button("Save") {
                        name = name
                        goal = goal
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
