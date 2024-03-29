//
//  ControlsView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/20/21.
//

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager

    var body: some View {
        HStack {
            VStack {
                Button {
                    
                    // End workout
                    workoutManager.endWorkout()
                    
                    // Play completion sound
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
    }
}
