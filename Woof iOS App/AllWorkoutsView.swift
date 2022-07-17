//
//  AllWorkoutsView.swift
//  Woof iOS App
//
//  Created by Michael Adams on 7/2/22.
//

import SwiftUI
import HealthKit

struct AllWorkoutsView: View {
    @State var allWorkouts: [HKWorkout]
    
    var body: some View {
        List(allWorkouts, id: \.self) { workout in
            VStack(alignment: .leading) {
                
                HStack {
                    workout.workoutActivityType.image
                        .font(.largeTitle)
                        .foregroundColor(.accentColor)
                    VStack(alignment: .leading) {
                        Text("\(workout.workoutActivityType.name)")
                            .font(.headline)
                        HStack {
                            let totalDistance: String = String(format: "%.2f", workout.totalDistance?.doubleValue(for: .mile()) ?? 0.0)
                            Text("\(totalDistance) mi")
                                .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                                .foregroundColor(.accentColor)
                            Spacer()
                            Text(workout.startDate, style: .date)
                                .font(.footnote)
                                .foregroundColor(.gray)
                            
                        }
                    }
                    
                    
                }
                
            }
            .padding()
            .navigationBarTitle("Workouts")
            .navigationBarTitleDisplayMode(.large)
        }
        .listStyle(.insetGrouped)
        
    }
}

//struct AllWorkoutsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AllWorkoutsView()
//    }
//}

extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }
    
    var name: String {
        switch self {
        case .walking:
            return "Walk"
        case .play:
            return "Play"
        default:
            return ""
        }
    }
    
    var image: Image {
        switch self {
        case .walking:
            return Image("pawprint")
        case .play:
            return Image("tennisball")
        default:
            return Image("pawprint")
        }
    }
}
