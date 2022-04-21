//
//  MetricsView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/20/21.
//

import SwiftUI
import HealthKit

struct WalkMetricsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @AppStorage("dog.goal") var goal: Int?
    
    var body: some View {
        
        TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date())) { context in
            VStack(alignment: .leading) {
                // Displays total workout time; combines today's exercise variable with current workout time
                TotalTimeProgressView(current: (-(workoutManager.builder?.startDate?.timeIntervalSinceNow ?? 0) + Double(workoutManager.todaysExercise ?? 0)), selectedWorkout: workoutManager.selectedWorkout)
                    .padding()
                    .ignoresSafeArea()
                    .scenePadding()
                VStack(alignment: .leading) {
                    // Displays total time of current workout
                    ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime ?? 0, showSubseconds: context.cadence == .live)
                        .foregroundColor(.green)
                    // Displays current heart rate
                    Text(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
                    // Displays distance walked
                    Text(Measurement(value: workoutManager.distance, unit: UnitLength.meters).formatted(.measurement(width: .abbreviated, usage: .road)))
                }
                .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                .frame(maxWidth: .infinity, alignment: .leading)
                .ignoresSafeArea(edges: .bottom)
                .scenePadding()
            }
        }
        
    }
}

struct WalkMetricsView_Previews: PreviewProvider {
    static var previews: some View {
        WalkMetricsView().environmentObject(WorkoutManager())
    }
}

private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date
    
    init(from startDate: Date) {
        self.startDate = startDate
    }
    
    func entries(from startDate: Date, mode: TimelineScheduleMode) -> PeriodicTimelineSchedule.Entries {
        PeriodicTimelineSchedule(from: self.startDate, by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0))
            .entries(from: startDate, mode: mode)
    }
}

