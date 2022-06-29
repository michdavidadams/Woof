//
//  DogStatsView.swift
//  Woof iOS App
//
//  Created by Michael Adams on 6/29/22.
//

import SwiftUI
import HealthKit

struct DogStatsView: View {
    
    @EnvironmentObject var healthStore: HealthStore
    @AppStorage("goal", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var goal: Int = 30
    @AppStorage("todaysExercise", store: UserDefaults(suiteName: "group.com.michdavidadams.WoofWorkout")) var todaysExercise: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text("Exercise")
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                        Text("\(todaysExercise)/\(goal) Min")
                            .font(.system(.title3, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                            .fontWeight(.semibold)
                            .foregroundColor(.accentColor)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    ZStack {
                    CircularProgressView(progress: Double(todaysExercise/goal))
                        Image("Pawprint")
                            .foregroundColor(Color.accentColor)
                            .font(.system(size: 25))
                    }.frame(width: 40, height: 40)
                }
            }
        }
        .onAppear {
            todaysExercise = healthStore.getTodaysExercise()
        }
        
    }
}


struct DogStatsView_Previews: PreviewProvider {
    static var previews: some View {
        DogStatsView().environmentObject(HealthStore())

    }
}

struct CircularProgressView: View {
    // 1
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.accentColor.opacity(0.5),
                    lineWidth: 5
                )
            Circle()
                // 2
                .trim(from: 0, to: progress)
                .stroke(
                    Color.accentColor,
                    style: StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
        }
    }
}

