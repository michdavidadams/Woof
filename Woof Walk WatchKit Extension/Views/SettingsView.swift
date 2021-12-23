//
//  SettingsView.swift
//  Woof Walk WatchKit Extension
//
//  Created by Michael Adams on 12/22/21.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var dog: Dog
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Dog name")
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                TextField("\(dog.name)", text: $dog.name)
            }
            .padding()
            VStack(alignment: .leading) {
                Text("Dog's exercise goal")
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                HStack {
                    Button("-") {
                        dog.exerciseGoal -= 5
                    }
                    Text("\(dog.exerciseGoal)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .padding(.horizontal)
                    Button("+") {
                        dog.exerciseGoal += 5
                    }
                }
            }
            .padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(dog: dog)
    }
}
