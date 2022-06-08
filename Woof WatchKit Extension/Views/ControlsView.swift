//
//  ControlsView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/20/21.
//

import SwiftUI
import CoreData

struct ControlsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.managedObjectContext) var viewContext

    var body: some View {
        HStack {
            VStack {
                Button {
                   let newWorkout = Workout(context: viewContext)
                    newWorkout.startDate = workoutManager.workout?.startDate
                    newWorkout.endDate = workoutManager.workout?.endDate
                    newWorkout.type = workoutManager.workout?.workoutActivityType.name
                    if workoutManager.workout?.workoutActivityType == .walking {
                        newWorkout.distance = workoutManager.workout?.totalDistance
                    }
                    newWorkout.distance = workoutManager.workout?.workoutActivityType.name
                    workoutManager.endWorkout()
                    WKInterfaceDevice.current().play(.success)
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
                    WKInterfaceDevice.current().play(.click)
                } label: {
                    Image(systemName: workoutManager.running ? "pause" : "play")
                }
                .tint(.accentColor)
                .font(.title2)
                Text(workoutManager.running ? "Pause" : "Resume")
            }
        }
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView().environmentObject(WorkoutManager())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)

    }
}
