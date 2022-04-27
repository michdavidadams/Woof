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
    @AppStorage("dog.goal") var goal: Int?
    @AppStorage("dog.todaysExercise") var todaysExercise: Int?
    
    var body: some View {
        VStack(alignment: .leading) {
            // Displays total workout time; combines today's exercise variable with current workout time
            TotalTimeProgressView(current: (Date.now.timeIntervalSince(workoutManager.builder?.startDate ?? Date.now) + Double(todaysExercise ?? 0) * 60), selectedWorkout: workoutManager.selectedWorkout)
                .padding()
                .scenePadding()
            TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date())) { context in
                VStack(alignment: .leading) {
                    // Displays total time of current workout
                    ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime ?? 0, showSubseconds: context.cadence == .live)
                        .foregroundColor(Color("darkGreen"))
                    // Displays current heart rate
                    Text(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
                    // Displays total calories burned
                    Text(Measurement(value: workoutManager.activeEnergy, unit: UnitEnergy.kilocalories)
                            .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle: .number.precision(.fractionLength(0)))))
                }
                .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                .frame(maxWidth: .infinity, alignment: .leading)
                .ignoresSafeArea(edges: .bottom)
                .scenePadding()
            }
        }
        .onAppear {
            updateStreak(recentExerciseMinutes: 0.0)
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

