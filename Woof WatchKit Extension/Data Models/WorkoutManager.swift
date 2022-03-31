//
//  WorkoutManager.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/20/21.
//

import Foundation
import HealthKit
import SwiftUI
import CoreLocation

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
    var myMetadata = ["Type of workout": "dog"]
    
    var routeBuilder: HKWorkoutRouteBuilder?
    var locationManager = CLLocationManager()
    
    @AppStorage("dog.goal") var goal: Int?
    @AppStorage("dog.currentStreak") var currentStreak: Int?
    var streakDateAwarded = Date.distantPast
    var exerciseDates: [Date: Int] = [:]
    
    // MARK: - Update today's exercise
    func todaysExercise() -> Int {
        guard let minutes = exerciseDates[Date.now.stripTime()] else { return 0 }
        return minutes
    }
    
    // Start the workout.
    func startWorkout(workoutType: HKWorkoutActivityType) {
        let configuration = HKWorkoutConfiguration()
        if workoutType == .walking {
            configuration.activityType = workoutType
            configuration.locationType = .outdoor
        } else if workoutType == .play {
            configuration.activityType = workoutType
            configuration.locationType = .indoor
        }
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
        locationManager.delegate = self
        
        // Set the workout builder's data source.
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                      workoutConfiguration: configuration)
        
        // Start the workout session and begin data collection.
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
            // The workout has started.
           
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        routeBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: nil)
        
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
            HKSeriesType.workoutRoute()
        ]

        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // Handle error.
        }
        
        // Request location authorization
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    func speed() {
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
    
    func resume() {
        session?.resume()
    }
    
    func endWorkout() {
        if exerciseDates.keys.contains(Date.now.stripTime()) {
            guard exerciseDates[Date.now.stripTime()] != nil else {
                exerciseDates[Date.now.stripTime()]! += Int(workout?.duration ?? 0) / 60
                return
            }
        } else {
            exerciseDates[Date.now.stripTime()] = Int(workout?.duration ?? 0) / 60
        }
        if (exerciseDates[Date.now.stripTime()] ?? 0 >= goal ?? 30) && !Calendar.current.isDateInToday(streakDateAwarded) {
            guard currentStreak != nil else {
                currentStreak = 0
                return
            }
            if currentStreak! >= 1 && Calendar.current.isDateInYesterday(streakDateAwarded) {
            currentStreak! += 1
            streakDateAwarded = Date.now
            } else if currentStreak! >= 1 {
                currentStreak = 0
            }
        }
        session?.end()
        showingSummaryView = true
        if workout != nil {
            routeBuilder?.finishRoute(with: workout!, metadata: myMetadata) { (newRoute, error) in
                guard newRoute != nil else {
                    // handle errors here
                    return
                }
                // can do something with route here
            }
        }
    }
    

    // MARK: - Workout Metrics
    @Published var activeEnergy: Double = 0
    @Published var distance: Double = 0
    @Published var workout: HKWorkout?
    @Published var totalTime: TimeInterval = 0
    
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }
        DispatchQueue.main.async {
            self.totalTime = -(statistics.startDate.timeIntervalSinceNow) + TimeInterval(self.todaysExercise() * 60)
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

extension WorkoutManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // filter raw data
        let filteredLocations = locations.filter { (location: CLLocation) -> Bool in
            location.horizontalAccuracy <= 50.0
        }
        
        guard !filteredLocations.isEmpty else { return }
        
        // add filtered data to route
        routeBuilder?.insertRouteData(filteredLocations) { (success, error) in
            if !success {
                // handle errors here
            }
        }
    }
}

extension Date {

    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }

}
