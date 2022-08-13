//
//  SettingsView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/22/21.
//

import SwiftUI

struct SettingsView: View {
    // Dog settings
    @AppStorage("name", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var name: String = "Your Dog"
    @AppStorage("goal", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var goal: Int = 30
    
    // Notification settings
    @AppStorage("notificationsOn", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var notificationsOn = true // Toggle
    @AppStorage("notificationFrequency", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var notificationFrequency: Int = 4 // In hours, default is every 4 hours
    
    var body: some View {
            List {
                Section("Dog Name") {
                    TextField("Dog name", text: $name)
                }
                Section("Exercise Goal") {
                    NavigationLink(destination: ExerciseGoalEditView(goal: $goal), label: {
                        Text("\(goal)")
                            .font(.system(.title3, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                    })
                }
                Section("Notifications") {
                    Toggle(isOn: $notificationsOn) {
                        Text("Enable")
                    }
                    if notificationsOn {
                        Picker("Frequency", selection: $notificationFrequency) {
                            ForEach(1...24, id: \.self) {
                                Text("Every \($0) hours")
                            }
                        }
                    }
                    
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
