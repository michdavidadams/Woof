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
        ScrollView {
            List(allWorkouts, id: \.self) { workout in
                HStack {
                    Text("\(workout.startDate)")
                }
            }
        }
    }
}

//struct AllWorkoutsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AllWorkoutsView()
//    }
//}
