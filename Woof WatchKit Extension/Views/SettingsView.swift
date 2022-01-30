//
//  SettingsView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/22/21.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var userSettings = UserSettings()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                
                VStack {
                    Text("DOG NAME")
                    TextField("Dog name", text: $userSettings.dogName)
                }
                .padding()
                
                VStack {
                    Text("EXERCISE GOAL")
                    HStack {
                        Button("-") {
                            userSettings.exerciseGoal -= 5
                        }
                        Text("\(userSettings.exerciseGoal)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .padding(.horizontal)
                        Button("+") {
                            userSettings.exerciseGoal += 5
                        }
                    }
                }
                .padding()
                
                VStack {
                    Button("Save") {
                        self.userSettings.dogName = userSettings.dogName
                        self.userSettings.exerciseGoal = userSettings.exerciseGoal
                    }
                }
                .padding()
            }
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
