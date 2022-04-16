//
//  ComplicationViews.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 4/16/22.
//

import SwiftUI

struct ComplicationViewGraphicCircular: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        TotalTimeGauge(current: TimeInterval(workoutManager.todaysExercise()), selectedWorkout: .walking)
    }
}
