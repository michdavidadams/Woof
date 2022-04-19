//
//  PlayMetricsView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 3/29/22.
//

import SwiftUI
import HealthKit

struct PlayMetricsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        VStack(alignment: .leading) {
            TotalTimeGauge(current: (-(workoutManager.builder?.startDate?.timeIntervalSinceNow ?? 0) + Double(workoutManager.todaysExercise ?? 0)), selectedWorkout: workoutManager.selectedWorkout)
                .padding()
                .ignoresSafeArea()
                .scenePadding()
            TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date())) { context in
                VStack(alignment: .leading) {
                    ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime ?? 0, showSubseconds: context.cadence == .live)
                        .foregroundColor(.green)
                    Text(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
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

struct PlayMetricsView_Previews: PreviewProvider {
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

