//
//  ExerciseGoalView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/24/21.
//

import SwiftUI
import ClockKit

struct ExerciseGoalView: View {
    @ObservedObject var dog = DogModel()
    @ObservedObject var walks = Walks()
    
    var body: some View {
        ProgressView(value: (walks.todaysWalks / Double(dog.goal))) {
            Image(systemName: "pawprint.fill")
        }
        .progressViewStyle(CircularProgressViewStyle(tint: .green))
    }
}

struct ExerciseGoalView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseGoalView()
        CLKComplicationTemplateGraphicCircularView(ExerciseGoalView()).previewContext()
    }
}
