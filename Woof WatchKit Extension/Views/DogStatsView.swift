//
//  DogStatsView.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 2/1/22.
//

import SwiftUI
import Combine

struct DogStatsView: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var walks: Walks
    var body: some View {
        VStack(alignment: .leading) {
            Text(userSettings.dogName)
                .font(.title3)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .padding()
            VStack(alignment: .leading) {
                Text("exercise")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                Text("\(Int(walks.todaysWalks))/\(userSettings.exerciseGoal) MIN")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.green)
                    .multilineTextAlignment(.leading)
            }
            VStack(alignment: .leading) {
                Text("streak")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                Text("\(Int(walks.streak)) DAYS")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.yellow)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}

struct DogStatsView_Previews: PreviewProvider {
    static var previews: some View {
        DogStatsView()
            .environmentObject(UserSettings())
            .environmentObject(Walks())
    }
}
