//
//  NotificationView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/20/21.
//

import SwiftUI

struct NotificationView: View {
    var title: String?
    var message: String?
    var todaysExercise: Int?
    var goal: Int?
    
    var body: some View {
        VStack {
            ProgressView(value: Double((todaysExercise ?? 0 / 60)), total: Double(goal ?? 30), label: {
                Image(systemName: "pawprint.fill")
                    .foregroundColor(Color("lightGreen"))
            })
            .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
            
            Text(title ?? "Today's Exercise")
                .font(.headline)
            
            Divider()
            
            Text(message ?? "Your dog's exercise stats for today.")
                .font(.caption)
        }
        .lineLimit(0)
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NotificationView()
            NotificationView(title: "Today's Exercise", message: "Exercise goal reached.", todaysExercise: 30, goal: 30)
        }
    }
}
