//
//  ExerciseItem.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 2/8/22.
//

import Foundation
import SwiftUI
import HealthKit

class ExerciseItem: ObservableObject, Identifiable {
    var date: Date
    @Published var length: Int64
    var type: String
    
    init(exercise: HKWorkout?) {
        date = exercise?.startDate ?? Date()
        length = Int64(exercise?.duration ?? 0)
        switch exercise?.workoutActivityType {
        case .walking:
            type = "walking"
        case .play:
            type = "playing"
        default:
            type = ""
        }
    }
    
    
}
