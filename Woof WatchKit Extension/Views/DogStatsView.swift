//
//  DogStatsView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 2/1/22.
//

import Combine
import SwiftUI
import HealthKit
import CoreData

struct DogStatsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: Exercise.todaysExercisesFetchRequest) var todaysExercise: FetchedResults<Exercise>
    @State var minutesFromExercise: [Int64]?
    @State var exerciseMinutesSum: Int64?
    @AppStorage("dog.name") var name: String?
    @AppStorage("dog.goal") var goal: Int?
    @AppStorage("dog.currentStreak") var currentStreak: Int?
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Text("🐶")
                        .font(.system(size: 25))
                        .padding(.trailing)
                    
                    VStack(alignment: .leading) {
                        Text("exercise")
                            .font(.footnote)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .textCase(.uppercase)
                        Text("\(exerciseMinutesSum ?? 0)/\(goal ?? 30) MIN")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.green)
                            .multilineTextAlignment(.leading)
                    }
                }
                Divider()
                HStack {
                    Text("🗓")
                        .font(.system(size: 25))
                        .padding(.trailing)
                    VStack(alignment: .leading) {
                        Text("streak")
                            .font(.footnote)
                            .foregroundColor(Color.white)
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
        }.onAppear {
            currentStreak = workoutManager.getStreak()
            minutesFromExercise = todaysExercise.map { $0.duration }
            exerciseMinutesSum = minutesFromExercise?.reduce(0, +)
            print("Exercise minutes sum: \(String(describing: exerciseMinutesSum))")
        }
        
    }
    
}

struct DogStatsView_Previews: PreviewProvider {
    static var previews: some View {
        DogStatsView().environmentObject(WorkoutManager())
    }
}
