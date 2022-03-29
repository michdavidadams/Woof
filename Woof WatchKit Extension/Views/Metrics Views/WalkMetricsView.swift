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
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "pawprint.fill")
                .foregroundColor(.accentColor)
                .font(.system(size: 30.0))
                .padding()
                .background(Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.gray, .green]), startPoint: .leading, endPoint: .trailing))
                    .opacity(0.5))
                .ignoresSafeArea()
                .scenePadding()
            TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date())) { context in
                VStack(alignment: .leading) {
                    TotalTimeView(totalTime: workoutManager.totalTime)
                        .foregroundStyle(.green)
                    ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime ?? 0, showSubseconds: context.cadence == .live)
                        .foregroundStyle(.yellow)
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

