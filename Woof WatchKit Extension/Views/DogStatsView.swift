//
//  DogStatsView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 2/1/22.
//

import SwiftUI
import HealthKit
import UserNotifications

struct DogStatsView: View {
    
    @EnvironmentObject var workoutManager: WorkoutManager
    @AppStorage("goal", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var goal: Int = 30
    @AppStorage("name", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var name: String = "Your Dog"
    @AppStorage("todaysExercise", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var todaysExercise: Int?
    @AppStorage("streak", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var streak: Int?
    @AppStorage("goalMetToday", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var goalMetToday: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(name)")
                .font(.system(size: 20))
                .fontWeight(.semibold)
                .foregroundColor(Color.white)
            VStack(alignment: .leading) {
                HStack {
                    Text("🐶")
                        .font(.system(size: 25))
                        .padding(.trailing)
                    
                    VStack(alignment: .leading) {
                        Text("Exercise")
                            .font(.system(.footnote, design: .default).lowercaseSmallCaps())
                            .foregroundColor(Color.gray)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .textCase(.uppercase)
                        Text("\(todaysExercise ?? 0)/\(goal) Min")
                            .font(.system(.title3, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                            .fontWeight(.semibold)
                            .foregroundColor(.accentColor)
                            .multilineTextAlignment(.leading)
                    }
                }
                HStack {
                    Text("🗓")
                        .font(.system(size: 25))
                        .padding(.trailing)
                    
                    VStack(alignment: .leading) {
                        Text("Streak")
                            .font(.system(.footnote, design: .default).lowercaseSmallCaps())
                            .foregroundColor(Color.gray)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .textCase(.uppercase)
                        if goalMetToday {
                            Text("\(streak ?? 0)")
                                .font(.system(.title3, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                                .fontWeight(.semibold)
                                .foregroundColor(.accentColor)
                                .multilineTextAlignment(.leading)
                        } else {
                            Text("\(streak ?? 0)")
                                .font(.system(.title3, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
            }
        }
        .onAppear {
            workoutManager.loadWalkingWorkouts()
            
        }
        
    }
}


struct DogStatsView_Previews: PreviewProvider {
    static var previews: some View {
        DogStatsView().environmentObject(WorkoutManager())

    }
}

