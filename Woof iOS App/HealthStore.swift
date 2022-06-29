//
//  HealthStore.swift
//  Woof iOS App
//
//  Created by Michael Adams on 6/29/22.
//

import Foundation
import HealthKit

class HealthStore: ObservableObject {
    
    let healthStore = HKHealthStore()
    
    // Request authorization to access HealthKit and location.
    func requestAuthorization() {
        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType(),
            HKSeriesType.workoutRoute()
        ]
        
        // The quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.activitySummaryType(),
            HKQuantityType.workoutType(),
            HKSeriesType.workoutRoute()
        ]
        
        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // Handle error.
        }
        
    }
    
    // MARK: Load past workouts
    @Published var walkingWorkouts: [HKWorkout] = []
    @Published var playWorkouts: [HKWorkout] = []
    
    func loadWalkingWorkouts() {
        //1. Get all workouts with the "Walking" activity type.
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .walking)
        
        //2. Get all workouts that only came from this app.
        let sourcePredicate = HKQuery.predicateForObjects(from: .default())
        
        //3. Combine the predicates into a single predicate.
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates:
          [workoutPredicate, sourcePredicate])
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
                                              ascending: true)
        
        let query = HKSampleQuery(
          sampleType: .workoutType(),
          predicate: compound,
          limit: 0,
          sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            DispatchQueue.main.async {
              guard
                let samples = samples as? [HKWorkout],
                error == nil
                else {
                  return
              }
                self.walkingWorkouts = samples
            }
          }
        HKHealthStore().execute(query)
    }
    
    func loadPlayWorkouts() {
        //1. Get all workouts with the "Play" activity type.
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .play)
        
        //2. Get all workouts that only came from this app.
        let sourcePredicate = HKQuery.predicateForObjects(from: .default())
        
        //3. Combine the predicates into a single predicate.
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates:
          [workoutPredicate, sourcePredicate])
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
                                              ascending: true)
        
        let query = HKSampleQuery(
          sampleType: .workoutType(),
          predicate: compound,
          limit: 0,
          sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            DispatchQueue.main.async {
              guard
                let samples = samples as? [HKWorkout],
                error == nil
                else {
                  return
              }
                self.playWorkouts = samples
            }
          }
        HKHealthStore().execute(query)
    }
    
    func getTodaysExercise() -> Int {
        self.loadWalkingWorkouts()
        self.loadPlayWorkouts()
        var todaysExercise: Int = 0
        self.playWorkouts.forEach { workout in
            if Calendar.current.isDateInToday(workout.startDate) {
                todaysExercise += Int(workout.endDate.timeIntervalSince(workout.startDate) / 60)
            }
        }
        self.walkingWorkouts.forEach { workout in
            if Calendar.current.isDateInToday(workout.startDate) {
                todaysExercise += Int(workout.endDate.timeIntervalSince(workout.startDate) / 60)
            }
        }
        print("Today's exercise: \(todaysExercise) minutes")
        
        return todaysExercise
    }
    
}
