//
//  ContentView.swift
//  Woof Walk WatchKit Extension
//
//  Created by Michael Adams on 12/20/21.
//

import SwiftUI
import HealthKit

struct MainMenuView: View {
    @State private var selection: Tab = .start

    enum Tab {
        case start, settings
        
        func returnTitle() -> String {
            switch self {
            case .start:
                return "Walk"
            case .settings:
                return "Settings"
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selection) {
            StartView().tag(Tab.start)
            SettingsView().tag(Tab.settings)
        }
        .navigationTitle(selection.returnTitle())
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView().environmentObject(WorkoutManager())
    }
}

