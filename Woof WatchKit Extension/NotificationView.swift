//
//  NotificationView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/20/21.
//

import SwiftUI

struct NotificationView: View {
    @AppStorage("goal", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var goal: Int = 30
    @AppStorage("name", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var name: String = "Your Dog"
    @AppStorage("todaysExercise", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var todaysExercise: Int?
    
    var body: some View {
        VStack {
            HStack {
                ProgressView(value: Double(todaysExercise ?? 0), total: Double(goal), label: {
                    Image("pawprint")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.accentColor)
                })
                .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                
                Text("\(todaysExercise ?? 0)/\(goal) Min")
                    .font(.system(.title3, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
                    .multilineTextAlignment(.leading)
            }
            if (todaysExercise ?? 0 >= goal) {
                Text("\(name)'s exercise goal reached!")
            } else {
                Text("\(goal - (todaysExercise ?? 0)) minutes left until \(name) reaches their goal.")
            }
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
