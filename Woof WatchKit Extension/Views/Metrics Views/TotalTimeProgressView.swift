//
//  TotalTimeProgressView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 4/6/22.
//

import SwiftUI
import HealthKit
import ClockKit

struct TotalTimeProgressView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    var current: TimeInterval
    @AppStorage("dog.goal") var maxValue: Int?
    var selectedWorkout: HKWorkoutActivityType?
    
    var body: some View {
        ProgressView(value: (current / 60), total: Double(maxValue ?? 30), label: {
            selectedWorkout?.image
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(Color.accentColor)
        })
        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
        
        
    }
}
