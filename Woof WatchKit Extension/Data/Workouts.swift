//
//  Workouts.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 4/16/22.
//

import Foundation
import HealthKit
import SwiftUI

class Workouts: ObservableObject {
    var type: HKWorkoutActivityType?
    var length: TimeInterval = 0
}
