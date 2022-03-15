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
    @AppStorage("streak") var streak: Int?
    
    @State var todaysExerciseMinutes: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(name ?? "Dog") 🐶")
                .font(.title3)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .padding()
            VStack(alignment: .leading) {
                Text("exercise")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                Text("\(Int(todaysExerciseMinutes))/\(goal ?? 30) MIN")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.green)
                    .multilineTextAlignment(.leading)
            }
            VStack(alignment: .leading) {
                Text("streak")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                Text("\(Int(streak ?? 0)) DAYS")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.yellow)
                    .multilineTextAlignment(.leading)
            }
        }.onAppear {
            workoutManager.loadExercises()
            todaysExerciseMinutes = workoutManager.todaysExercise ?? 0
            
        }
    }

}

struct DogStatsView_Previews: PreviewProvider {
    static var previews: some View {
        DogStatsView().environmentObject(WorkoutManager())
    }
}
