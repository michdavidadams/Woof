//
//  MetricsView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/20/21.
//

import SwiftUI
import HealthKit

struct MetricsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date())) { context in
            VStack(alignment: .leading) {
                TotalTimeView(totalTime: (workoutManager.builder?.startDate)?.timeIntervalSinceNow ?? 0)
                    .foregroundStyle(.green)
                    .minimumScaleFactor(0.5)
                    .scaledToFit()
                ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime ?? 0, showSubseconds: context.cadence == .live)
                    .foregroundStyle(.yellow)
                Text(Measurement(value: workoutManager.activeEnergy, unit: UnitEnergy.kilocalories)
                    .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle: .number.precision(.fractionLength(0)))))
                .foregroundStyle(.red)
                Text(Measurement(value: workoutManager.distance, unit: UnitLength.meters).formatted(.measurement(width: .abbreviated, usage: .road)))
                    .foregroundStyle(.cyan)
            }
            .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
            .frame(maxWidth: .infinity, alignment: .leading)
            .ignoresSafeArea(edges: .bottom)
            .scenePadding()
        }
    }
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView().environmentObject(WorkoutManager())
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

