//
//  Gauge.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 4/6/22.
//

import SwiftUI
import HealthKit
import ClockKit

struct TotalTimeProgressView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    var current: TimeInterval = 0
    @AppStorage("dog.goal") var maxValue: Int?
    var selectedWorkout: HKWorkoutActivityType?
    
    var body: some View {
        ProgressView(value: (current / 60), total: Double(maxValue ?? 30), label: {
            Image(systemName: "pawprint.fill")
                .foregroundColor(Color("lightGreen"))
        })
        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
    }
}
