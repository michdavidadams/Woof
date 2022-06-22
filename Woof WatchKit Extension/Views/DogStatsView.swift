//
//  DogStatsView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 2/1/22.
//

import SwiftUI
import HealthKit

struct DogStatsView: View {
    
    @EnvironmentObject var workoutManager: WorkoutManager
    @AppStorage("goal") var goal: Int = 30
    
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
                        Text("\(workoutManager.todaysExercise)/\(goal) Min")
                            .font(.system(.title3, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                            .fontWeight(.semibold)
                            .foregroundColor(.accentColor)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
        }
        .onAppear {
            workoutManager.getTodaysExercise()
        }
        
    }
}


struct DogStatsView_Previews: PreviewProvider {
    static var previews: some View {
        DogStatsView().environmentObject(WorkoutManager())

    }
}

