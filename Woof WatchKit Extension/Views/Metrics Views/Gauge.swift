//
//  Gauge.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 4/6/22.
//

import SwiftUI
import HealthKit

struct TotalTimeGauge: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    var current: TimeInterval = 0
    let minValue = 0.0
    @AppStorage("dog.goal") var maxValue: Int?
    var selectedWorkout: HKWorkoutActivityType?
    
    var body: some View {
        Gauge(value: (current / 60), in: minValue...Double(maxValue ?? 30)) {
            Image(systemName: "pawprint.fill")
                .foregroundColor(.green)
        } currentValueLabel: {
            if selectedWorkout == .play {
                Image("tennisBall")
                    .foregroundColor(.green)
            } else {
                Image(systemName: "pawprint.fill")
                    .foregroundColor(.green)
            }
        } minimumValueLabel: {
            Text("\(Int(minValue))")
                .foregroundColor(.gray)
        } maximumValueLabel: {
            Text("\(Int(maxValue ?? 30))")
                .foregroundColor(.gray)
        }
        .gaugeStyle(CircularGaugeStyle(tint: .green))
    }
}
