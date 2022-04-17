//
//  ControlsView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/20/21.
//

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Exercise.todaysExercisesFetchRequest) var todaysExercise: FetchedResults<Exercise>
    @State var minutesFromExercise: [Int64]?
    @State var exerciseMinutesSum: Int64?

    var body: some View {
        HStack {
            VStack {
                Button {
                    let exercise = Exercise(context: managedObjectContext)
                    exercise.id = UUID()
                    exercise.date = Date.now.stripTime()
                    exercise.duration = Int64(workoutManager.totalTime / 60)
                    do {
                        try managedObjectContext.save()
                    } catch {
                        // error
                    }
                    workoutManager.endWorkout()
                } label: {
                    Image(systemName: "xmark")
                }
                .tint(.red)
                .font(.title2)
                Text("End")
            }
            VStack {
                Button {
                    workoutManager.togglePause()
                } label: {
                    Image(systemName: workoutManager.running ? "pause" : "play")
                }
                .tint(.yellow)
                .font(.title2)
                Text(workoutManager.running ? "Pause" : "Resume")
            }
        }
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView().environmentObject(WorkoutManager())
    }
}
