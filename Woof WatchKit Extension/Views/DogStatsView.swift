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
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("exercise")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .textCase(.uppercase)
                    Text("\(workoutManager.todaysExercise())/\(goal ?? 30) MIN")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(lightGreen ?? .green))
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("streak")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                    Text("\(currentStreak ?? 0) DAYS")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.yellow)
                        .multilineTextAlignment(.leading)
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
