//
//  TotalTimeView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 3/16/22.
//

import SwiftUI

struct TotalTimeView: View {
    var totalTime: TimeInterval = 0
    @State private var timeFormatter = TotalTimeFormatter()
    @AppStorage("dog.goal") var goal: Int?

    var body: some View {
        Text("\(NSNumber(value: totalTime), formatter: timeFormatter)/\(goal ?? 30) Min")
            .fontWeight(.semibold)
            .lineLimit(1)
    }
}

class TotalTimeFormatter: Formatter {
    let componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()

    override func string(for value: Any?) -> String? {
        guard let time = value as? TimeInterval else {
            return nil
        }

        guard let formattedString = componentsFormatter.string(from: time) else {
            return nil
        }


        return formattedString
    }
}

struct TotalTimeView_Previews: PreviewProvider {
    static var previews: some View {
        TotalTimeView()
    }
}
