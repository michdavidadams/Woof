//
//  ComplicationController.swift
//  Woof Walk WatchKit Extension
//
//  Created by Michael Adams on 12/20/21.
//

import ClockKit
import SwiftUI

class ComplicationController: NSObject, CLKComplicationDataSource {
    @ObservedObject var walks = Walks()
    @ObservedObject var userSettings = UserSettings()
    
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "ExerciseGoal", displayName: "Exercise Goal", supportedFamilies: CLKComplicationFamily.allCases)
            // Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.hideOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        let gaugeProvider = CLKSimpleGaugeProvider(style: .ring, gaugeColor: .green, fillFraction: Float((walks.todaysWalks / Double(userSettings.exerciseGoal))))
        let centerTextProvider = CLKSimpleTextProvider(text: String("\(Image(systemName: "pawprint.fill"))"))
        handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: CLKComplicationTemplateGraphicCircularClosedGaugeText(gaugeProvider: gaugeProvider, centerTextProvider: centerTextProvider)))
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        handler(nil)
    }
    
    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        
        switch (complication.family) {
        case (.graphicCircular):
            let gaugeProvider = CLKSimpleGaugeProvider(style: .ring, gaugeColor: .green, fillFraction: Float((walks.todaysWalks / Double(userSettings.exerciseGoal))))
            let centerTextProvider = CLKSimpleTextProvider(text: String(format: "%0.f", walks.todaysWalks))
            handler(CLKComplicationTemplateGraphicCircularClosedGaugeText(gaugeProvider: gaugeProvider, centerTextProvider: centerTextProvider))
        default:
            handler(nil)
        }
    }
    
}
