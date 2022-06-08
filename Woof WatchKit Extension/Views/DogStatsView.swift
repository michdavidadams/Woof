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
    
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Workout.startDate, ascending: false)],
        animation: .default)
    var workouts: FetchedResults<Workout>
    
    @EnvironmentObject var workoutManager: WorkoutManager
    @AppStorage("dog.name") var name: String?
    @AppStorage("dog.goal") var goal: Int?
    @State var todaysExercise: Int?
    
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
//                HStack {
//                    Text("🗓")
//                        .font(.system(size: 25))
//                        .padding(.trailing)
//                    VStack(alignment: .leading) {
//                        Text("Streak")
//                            .font(.system(.footnote, design: .default).lowercaseSmallCaps())
//                            .foregroundColor(Color.white)
//                            .multilineTextAlignment(.leading)
//                            .lineLimit(1)
//                            .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
//                        Text("\(currentStreak ?? 0) Days")
//                            .font(.system(.title3, design: .rounded).monospacedDigit().lowercaseSmallCaps())
//                            .fontWeight(.semibold)
//                            .foregroundColor(Color("lightGreen"))
//                            .multilineTextAlignment(.leading)
//                    }
//                }
            }
        }
        .onAppear {
            todaysWorkouts()
        }
        
    }
    func todaysWorkouts() {
        var total = 0.0
        
        // Put all workouts into streaks dictionary
        workouts.filter{ Calendar.current.isDateInToday($0.startDate ?? Date.distantPast) }.forEach { workout in
            guard let endDate = workout.endDate else {
                return
            }
            guard let startDate = workout.startDate else {
                return
            }
            total += (startDate.distance(to: endDate))
        }
        todaysExercise = Int(total) / 60
    }
}


struct DogStatsView_Previews: PreviewProvider {
    static var previews: some View {
        DogStatsView().environmentObject(WorkoutManager())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)

    }
}

