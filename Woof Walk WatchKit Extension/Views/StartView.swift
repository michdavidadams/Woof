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
    @StateObject var currentDog = dog
    
    var workoutType: HKWorkoutActivityType = .walking
    
    var body: some View {
        
        LazyVStack {
            Text("🦮🚶🏼‍♂️")
                .padding()
            NavigationLink(workoutType.name, destination: SessionPagingView(), tag: workoutType, selection: $workoutManager.selectedWorkout)
        }
        .padding([.bottom, .trailing])
        .navigationBarTitle($dog.name)
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
