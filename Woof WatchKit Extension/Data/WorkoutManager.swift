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
import CoreMotion
import Combine
import CoreData

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
    
    @Environment(\.managedObjectContext) var managedObjectContext
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    public var builder: HKLiveWorkoutBuilder?
    var myMetadata = ["Type of workout": "dog"]
    var pedometer: CMPedometer?
    var pace: Double = 0
    
    var routeBuilder: HKWorkoutRouteBuilder?
    var locationManager: CLLocationManager?
    
    @AppStorage("dog.goal") var goal: Int?
    @AppStorage("dog.currentStreak") var currentStreak: Int?
    var exerciseDates: [Date: Int] = [:]
    var walkingWorkouts: [HKSample]?
    var playWorkouts: [HKSample]?
    
    // MARK: - Update today's exercise
    func todaysExercise() -> Int {
        guard let minutes = exerciseDates[Date.now.stripTime()] else { return 0 }
        print("todaysExercise(): \(minutes)")
        print("exerciseDates: \(exerciseDates)")
        return minutes
    }
    
    // MARK: - Get/Update streak
    func getStreak() -> Int {
        var streak = 0
        for i in 0...exerciseDates.keys.count {
            guard let date = Calendar.current.date(byAdding: .day, value: i, to: Date.now) else { return streak }
            guard let exerciseMinutes = exerciseDates[date.stripTime()] else { return streak }
            if exerciseMinutes >= (goal ?? 30) {
                streak += 1
            } else {
                return streak
            }
        }
        return streak
    }
    
    // Start the workout.
    func startWorkout(workoutType: HKWorkoutActivityType) {
        let configuration = HKWorkoutConfiguration()
        if workoutType == .walking {
            configuration.activityType = workoutType
            configuration.locationType = .outdoor
            // location support
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
            routeBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: nil)
            pedometer = CMPedometer()
            startPedometerUpdates()
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
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.activitySummaryType(),
            HKQuantityType.workoutType(),
            HKSeriesType.workoutRoute()
        ]
        
        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // Handle error.
        }
        
        // Request location authorization
        locationManager?.requestWhenInUseAuthorization()
        
    }
    
    // MARK: - Session State Control
    
    // The app's workout state.
    @Published var running = false
    
    func togglePause() {
        print("togglePause()")
        if running == true {
            self.pause()
        } else {
            resume()
        }
    }
    
    func pause() {
        print("pause()")
        session?.pause()
    }
    
    func resume() {
        print("resume()")
        session?.resume()
    }
    
    func endWorkout() {
        print(exerciseDates)
        if exerciseDates.keys.contains(Date.now.stripTime()) {
            exerciseDates[Date.now.stripTime()]! += Int(workoutTime / 60)
        } else {
            exerciseDates[Date.now.stripTime()] = Int(workoutTime / 60)
        }
        let exercise = Exercise(context: managedObjectContext)
        exercise.id = UUID()
        exercise.date = Date.now.stripTime()
        exercise.duration = Int64(workoutTime / 60)
        do {
            try managedObjectContext.save()
        } catch {
            // error
        }
        
        session?.end()
        if workout?.workoutActivityType == .walking {
            if workout != nil {
                routeBuilder?.finishRoute(with: workout!, metadata: myMetadata) { (newRoute, error) in
                    guard newRoute != nil else {
                        // handle errors here
                        return
                    }
                    // can do something with route here
                }
            }
            stopMotionUpdates()
        }
        showingSummaryView = true
    }
    
    // MARK: - Workout Metrics
    @Published var activeEnergy: Double = 0
    @Published var distance: Double = 0
    @Published var heartRate: Double = 0
    @Published var workout: HKWorkout?
    @Published var totalTime: TimeInterval = 0
    var workoutTime: TimeInterval = 0
    
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }
        DispatchQueue.main.async {
            self.totalTime = -(statistics.startDate.timeIntervalSinceNow) + TimeInterval(self.todaysExercise() * 60)
            self.workoutTime = -statistics.startDate.timeIntervalSinceNow
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
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
        locationManager = nil
        routeBuilder = nil
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

// MARK: - Pedometer functions
extension WorkoutManager {
    private var isPedometerAvailable: Bool{
        return CMPedometer.isPedometerEventTrackingAvailable() && CMPedometer.isPaceAvailable()
    }
    
    func startPedometerUpdates() {
        if isPedometerAvailable {
            pedometer?.startUpdates(from: Date.now, withHandler: { data, error in
                guard let data = data, error == nil else { return }
                self.pace = data.currentPace?.doubleValue ?? 0
                print(self.pace)
                if self.pace == 0 {
                    print("pace = 0, so pause")
                    self.builder?.addWorkoutEvents([HKWorkoutEvent(type: .pause, dateInterval: DateInterval(start: Date(), duration: 0), metadata: [:])]) { success, error in
                    }
                } else if self.pace > 0 {
                    print("pace > 0, so resume")
                    self.builder?.addWorkoutEvents([HKWorkoutEvent(type: .resume, dateInterval: DateInterval(start: Date(), duration: 0), metadata: [:])]) { success, error in
                    }
                }
            })
        }
    }
    
    func stopMotionUpdates() {
        if CMPedometer.isPaceAvailable() {
            pedometer?.stopUpdates()
        } else {
            print("no pedometer to stop")
        }
    }
}
