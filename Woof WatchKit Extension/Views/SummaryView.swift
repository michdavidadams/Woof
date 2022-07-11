//
//  SummaryView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/20/21.
//

import Foundation
import HealthKit
import SwiftUI
import WatchKit

struct SummaryView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.dismiss) var dismiss
    @State private var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    @AppStorage("name", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var name: String?
    @AppStorage("goal", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var goal: Int?
    
    var body: some View {
        if workoutManager.workout == nil {
            ProgressView("Saving Workout")
                .navigationBarHidden(true)
                .foregroundColor(.accentColor)
        } else {
            ScrollView {
                VStack(alignment: .leading) {
                    SummaryMetricView(title: "Duration",
                                      value: durationFormatter.string(from: Date.now.timeIntervalSince(workoutManager.workout?.startDate ?? Date.now)) ?? "")
                    .foregroundStyle(Color.accentColor)
                    SummaryMetricView(title: "Distance",
                                      value: Measurement(value: workoutManager.workout?.totalDistance?.doubleValue(for: .meter()) ?? 0,
                                                         unit: UnitLength.meters)
                                        .formatted(.measurement(width: .abbreviated,
                                                                usage: .road,
                                                                numberFormatStyle: .number.precision(.fractionLength(2)))))
                        .foregroundStyle(.blue)
                    SummaryMetricView(title: "Energy",
                                      value: Measurement(value: workoutManager.workout?.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0,
                                                         unit: UnitEnergy.kilocalories)
                                        .formatted(.measurement(width: .abbreviated,
                                                                usage: .workout,
                                                                numberFormatStyle: .number.precision(.fractionLength(0)))))
                        .foregroundStyle(.red)
                    SummaryMetricView(title: "\(name ?? "Dog")'s Goal",
                                      value: "\(workoutManager.todaysExercise)/\(goal ?? 30) Min")
                    .foregroundStyle(Color.accentColor)
                    Text("Activity Rings")
                    ActivityRingsView(healthStore: workoutManager.healthStore)
                        .frame(width: 50, height: 50)
                    Button("Done") {
                        dismiss()
                    }
                }
                .scenePadding()
            }
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView().environmentObject(WorkoutManager())
    }
}

struct SummaryMetricView: View {
    var title: String
    var value: String

    var body: some View {
        Text(title)
            .foregroundStyle(.foreground)
        Text(value)
            .font(.system(.title2, design: .rounded).lowercaseSmallCaps())
        Divider()
    }
}
