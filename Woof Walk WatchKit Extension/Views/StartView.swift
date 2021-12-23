//
//  StartView.swift
//  Woof Walk WatchKit Extension
//
//  Created by Michael Adams on 12/22/21.
//

import SwiftUI
import HealthKit

struct StartView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State var dogName = dog.name
    @State var todaysWalks = dog.todaysWalks
    @State var exerciseGoal = dog.exerciseGoal
    @State var goalProgress = dog.currentProgress()
    
    var workoutType: HKWorkoutActivityType = .walking
    
    var body: some View {
        
        LazyVStack {
            HStack {
                Text("\(dogName)'s Walks:")
                Gauge(value: goalProgress, in: 0...Double(exerciseGoal)) {
                    Text("Exercise")
                }
            }
            NavigationLink("Begin Walk", destination: SessionPagingView(), tag: workoutType, selection: $workoutManager.selectedWorkout)
        }
        .padding([.bottom, .trailing])
        .onAppear {
            workoutManager.requestAuthorization()
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}

extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }

    var name: String {
        switch self {
        case .walking:
            return "Walk"
        default:
            return ""
        }
    }
}
