//
//  DogStatsView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 2/1/22.
//

import Combine
import SwiftUI
import HealthKit

struct DogStatsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @AppStorage("dog.name") var name: String?
    @AppStorage("dog.goal") var goal: Int?
    @AppStorage("dog.currentStreak") var currentStreak: Int?
    @AppStorage("dog.todaysExercise") var todaysExercise: Int?
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Text("🐶")
                        .font(.system(size: 25))
                        .padding(.trailing)
                    
                    VStack(alignment: .leading) {
                        Text("Exercise")
                            .font(.system(.footnote, design: .default).lowercaseSmallCaps())
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .textCase(.uppercase)
                        Text("\(todaysExercise ?? 0)/\(goal ?? 30) Min")
                            .font(.system(.title3, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                            .fontWeight(.semibold)
                            .foregroundColor(.accentColor)
                            .multilineTextAlignment(.leading)
                    }
                }
                Divider()
                HStack {
                    Text("🗓")
                        .font(.system(size: 25))
                        .padding(.trailing)
                    VStack(alignment: .leading) {
                        Text("Streak")
                            .font(.system(.footnote, design: .default).lowercaseSmallCaps())
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                        Text("\(currentStreak ?? 0) Days")
                            .font(.system(.title3, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                            .fontWeight(.semibold)
                            .foregroundColor(Color("lightGreen"))
                            .multilineTextAlignment(.leading)
                    }
                }
            }
        }
        
    }
    
}

struct DogStatsView_Previews: PreviewProvider {
    static var previews: some View {
        DogStatsView().environmentObject(WorkoutManager())
    }
}
