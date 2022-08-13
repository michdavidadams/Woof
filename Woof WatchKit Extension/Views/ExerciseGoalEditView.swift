//
//  ExerciseGoalEditView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 8/8/22.
//

import SwiftUI

struct ExerciseGoalEditView: View {
    @Binding var goal: Int
    
    var body: some View {
        VStack(alignment: .center) {
            
            HStack(alignment: .center) {
                Button(action: {
                    goal -= 5
                }) {
                    Label("Increase", systemImage: "minus.circle.fill")
                        .labelStyle(.iconOnly)
                        .font(.title2)
                }
                .buttonStyle(.borderless)
                Spacer()
                VStack(alignment: .center) {
                    Text("\(goal)")
                        .font(.system(size: 50, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                    Text("MINUTES")
                        .font(.system(size: 15, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .foregroundColor(.accentColor)
                }
                Spacer()
                Button(action: {
                    goal += 5
                }) {
                    Label("Increase", systemImage: "plus.circle.fill")
                        .labelStyle(.iconOnly)
                        .font(.title2)
                }
                .buttonStyle(.borderless)
            }
            .padding(.vertical)
            Spacer()
            
//            Button("Save") {
//                goal = goal
//            }
//            .buttonBorderShape(.capsule)
//            .buttonStyle(.borderedProminent)
//            .foregroundColor(.black)
//            .padding(.top)
            
            .navigationTitle("Exercise Goal")
        }
    }
}

//struct ExerciseGoalEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseGoalEditView(goal: 30)
//    }
//}

//struct GreenButton: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .padding()
//            .background(Color.accentColor)
//            .foregroundColor(.black)
//            .clipShape(Capsule())
//    }
//}
