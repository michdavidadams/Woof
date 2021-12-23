//
//  SettingsView.swift
//  Woof Walk WatchKit Extension
//
//  Created by Michael Adams on 12/22/21.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var userSettings = UserSettings()
    
    var body: some View {
        
        Form {
            Section(header: Text("DOG INFO")) {
                TextField("Dog name", text: $userSettings.dogName)
            }
            
            Section(header: Text("EXERCISE GOAL")) {
                
                Text("\(userSettings.exerciseGoal)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .padding(.horizontal)
                Button("+") {
                    userSettings.exerciseGoal += 5
                }
                Button("-") {
                    userSettings.exerciseGoal -= 5
                }
            }
            
            Section {
                Button("Save") {
                    self.userSettings.dogName = userSettings.dogName
                    self.userSettings.exerciseGoal = userSettings.exerciseGoal
                }
            }
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
