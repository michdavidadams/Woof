//
//  WorkoutManager.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/20/21.
//

import Foundation
import HealthKit
import SwiftUI

class WorkoutManager: NSObject, ObservableObject {
    
    
    var selectedWorkout: HKWorkoutActivityType? {
        didSet {
            guard let selectedWorkout = selectedWorkout else { return }
            startWorkout(workoutType: selectedWorkout)
        }
    }
    
    @Published var showingSummaryView: Bool = false {
        didSet {
            if showingSummaryView == false {
                resetWorkout()
            }
        }
    }
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    @AppStorage("dog.goal") var goal: Int?
    @AppStorage("dog.currentStreak") var currentStreak: Int?
    var walkingWorkouts: [HKSample]?
    var playWorkouts: [HKSample]?
    var todaysExercise: Int?
    var newDay = Date.distantPast   // for tracking a new day; when to reset today's exercise
    var streakDateAwarded: Date?
    
    // MARK: - Update streak
    func updateStreak() {
        // Reset today's exercise
        if !Calendar.current.isDateInToday(newDay) {
            todaysExercise = 0
        }
        // If streak wasn't awarded yesterday or today, clear streak
        if !Calendar.current.isDateInYesterday(streakDateAwarded ?? Date.distantFuture) && !Calendar.current.isDateInToday(streakDateAwarded ?? Date.distantPast) {
            currentStreak = 0
        }
        // If exercise goal reached & streak hasn't been awarded today
        if todaysExercise ?? 0 >= goal ?? 30 && !Calendar.current.isDateInToday(streakDateAwarded ?? Date.distantPast) {
            currentStreak! += 1
            streakDateAwarded = Date.now
        }
    }
    
    // Read previous workouts
    func loadExercises() {
        // Only get workouts from this app
        let sourcePredicate = HKQuery.predicateForObjects(from: .default())
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
                                              ascending: true)
        
        // Get walking workouts
        let walkingPredicate = HKQuery.predicateForWorkouts(with: .walking)
        let walkingCompound = NSCompoundPredicate(andPredicateWithSubpredicates:
                                            [walkingPredicate, sourcePredicate])
        let walkingWorkoutsQuery = HKSampleQuery(
            sampleType: .workoutType(),
            predicate: walkingCompound,
            limit: 0,
            sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                DispatchQueue.main.async {
                    self.walkingWorkouts = samples
                }
            }
        HKHealthStore().execute(walkingWorkoutsQuery)
        
        // Get play workouts
        let playPredicate = HKQuery.predicateForWorkouts(with: .play)
        let playCompound = NSCompoundPredicate(andPredicateWithSubpredicates:
                                            [playPredicate, sourcePredicate])
        let playWorkoutsQuery = HKSampleQuery(
            sampleType: .workoutType(),
            predicate: playCompound,
            limit: 0,
            sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                DispatchQueue.main.async {
                    self.playWorkouts = samples
                }
            }
        HKHealthStore().execute(playWorkoutsQuery)
    }

    // Start the workout.
    func startWorkout(workoutType: HKWorkoutActivityType) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .outdoor

        // Create the session and obtain the workout builder.
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            // Handle any exceptions.
            return
        }

        // Setup session and builder.
        session?.delegate = self
        builder?.delegate = self

        // Set the workout builder's data source.
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                     workoutConfiguration: configuration)
        
        // Start the workout session and begin data collection.
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
            // The workout has started.
        }
    }

    // Request authorization to access HealthKit and location.
    func requestAuthorization() {
        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType(),
            HKSeriesType.workoutRoute(),
        ]

        // The quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.activitySummaryType(),
            HKSeriesType.workoutRoute(),
            HKQuantityType.workoutType(),
            HKSeriesType.workoutType()
        ]

        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // Handle error.
        }
        
    }

    // MARK: - Session State Control

    // The app's workout state.
    @Published var running = false

    func togglePause() {
        if running == true {
            self.pause()
        } else {
            resume()
        }
    }
    
    func pause() {
        session?.pause()
    }
    
    func autoPause() {
        builder?.workoutSession?.pause()
    }

    func resume() {
        session?.resume()
    }

    func endWorkout() {
        todaysExercise! += Int(totalTime / 60)
        session?.end()
        showingSummaryView = true
    }

    // MARK: - Workout Metrics
    @Published var activeEnergy: Double = 0
    @Published var distance: Double = 0
    @Published var workout: HKWorkout?
    @Published var totalTime: TimeInterval = 0
    
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }
        DispatchQueue.main.async {
            self.totalTime = -(statistics.startDate.timeIntervalSinceNow) + TimeInterval((self.todaysExercise ?? 0) * 60)
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            default:
                return
            }
        }
    }

    func resetWorkout() {
        selectedWorkout = nil
        builder = nil
        workout = nil
        session = nil
        activeEnergy = 0
        distance = 0
    }
}

// MARK: - HKWorkoutSessionDelegate
extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState, date: Date) {
        DispatchQueue.main.async {
            self.running = toState == .running
        }

        // Wait for the session to transition states before ending the builder.
        if toState == .ended {
            builder?.endCollection(withEnd: date) { (success, error) in
                self.builder?.finishWorkout { (workout, error) in
                    DispatchQueue.main.async {
                        self.workout = workout
                    }
                }
            }
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
    }
}

// MARK: - HKLiveWorkoutBuilderDelegate
extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        
        let lastEvent = workoutBuilder.workoutEvents.last
        DispatchQueue.main.async() {
            if lastEvent?.type == .motionPaused {
                workoutBuilder.workoutSession?.pause()
            } else if lastEvent?.type == .motionResumed {
                workoutBuilder.workoutSession?.resume()
            }

        }
    }

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return // Nothing to do.
            }

            let statistics = workoutBuilder.statistics(for: quantityType)

            // Update the published values.
            updateForStatistics(statistics)
        }
    }
}
