//
//  RecentWorkoutView.swift
//  Woof iOS App
//
//  Created by Michael Adams on 7/3/22.
//

import SwiftUI
import HealthKit

struct RecentWorkoutView: View {
    var workout: HKWorkout?
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                workout?.workoutActivityType.image
                    .font(.largeTitle)
                    .foregroundColor(.accentColor)
                VStack(alignment: .leading) {
                    Text("\(workout?.workoutActivityType.name ?? HKWorkoutActivityType.walking.name)")
                        .font(.headline)
                    HStack {
                        let totalDistance: String = String(format: "%.2f", workout?.totalDistance?.doubleValue(for: .mile()) ?? 0.0)
                        Text("\(totalDistance) mi")
                            .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                            .foregroundColor(.accentColor)
                        Spacer()
                        Text(workout?.startDate ?? Date.distantPast, style: .date)
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                    }
                }
                
                
            }
            
        }
            .padding()
        
    }
}

//struct RecentWorkoutView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecentWorkoutView(recentWorkout: <#Binding<HKWorkout?>#>)
//    }
//}
