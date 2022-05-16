//
//  ComplicationController.swift
//  Woof WatchKit Extension
//
//  Created by Michael Adams on 12/20/21.
//

import ClockKit
import SwiftUI

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration
    
    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "Woof", supportedFamilies: [CLKComplicationFamily.graphicCircular, CLKComplicationFamily.circularSmall, CLKComplicationFamily.extraLarge, CLKComplicationFamily.modularSmall, CLKComplicationFamily.modularLarge, CLKComplicationFamily.utilitarianSmall, CLKComplicationFamily.utilitarianSmallFlat, CLKComplicationFamily.utilitarianLarge, CLKComplicationFamily.graphicCorner, CLKComplicationFamily.graphicBezel, CLKComplicationFamily.graphicRectangular])
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
        if let template = getComplicationTemplate(for: complication, using: Date()) {
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        } else {
            handler(nil)
        }
    }
    
    func getComplicationTemplate(for complication: CLKComplication, using date: Date) -> CLKComplicationTemplate? {
        @AppStorage("dog.name") var dogsName: String?
        @AppStorage("dog.todaysExercise") var todaysExercise: Int?
        @AppStorage("dog.goal") var goal: Int?
        let currentFraction: Double = (Double(todaysExercise ?? 0) / Double(goal ?? 30))
        print("Current fraction in getComplicationTemplate: \(currentFraction)")

        switch complication.family {
        case .graphicCircular:
            let pawprintImage = Image("Pawprint").resizable().scaledToFit().frame(width: 20, height: 20).foregroundColor(Color.accentColor)
            let gaugeProvider = CLKSimpleGaugeProvider(style: .ring, gaugeColor: UIColor(Color.accentColor), fillFraction: Float(currentFraction))
            return CLKComplicationTemplateGraphicCircularClosedGaugeView(gaugeProvider: gaugeProvider, label: pawprintImage)
        case .circularSmall:
            let imageProvider = CLKImageProvider(onePieceImage: UIImage(imageLiteralResourceName: "Pawprint"))
            return CLKComplicationTemplateCircularSmallRingImage(imageProvider: imageProvider, fillFraction: Float(currentFraction), ringStyle: .closed)
        case .extraLarge:
            let imageProvider = CLKImageProvider(onePieceImage: UIImage(imageLiteralResourceName: "Pawprint"))
            return CLKComplicationTemplateExtraLargeRingImage(imageProvider: imageProvider, fillFraction: Float(currentFraction), ringStyle: .closed)
        case .modularSmall:
            let imageProvider = CLKImageProvider(onePieceImage: UIImage(imageLiteralResourceName: "Pawprint"))
            return CLKComplicationTemplateModularSmallRingImage(imageProvider: imageProvider, fillFraction: Float(currentFraction), ringStyle: .closed)
        case .modularLarge:
            let headerTextProvider = CLKSimpleTextProvider(text: "\(dogsName ?? "Dog")'s Exercise")
            let bodyTextProvider = CLKSimpleTextProvider(text: "\(todaysExercise ?? 0) Min")
            return CLKComplicationTemplateModularLargeTallBody(headerTextProvider: headerTextProvider, bodyTextProvider: bodyTextProvider)
        case .utilitarianSmall:
            let textProvider = CLKSimpleTextProvider(text: "\(todaysExercise ?? 0) Min")
            return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: textProvider)
        case .utilitarianSmallFlat:
            let textProvider = CLKSimpleTextProvider(text: "\(todaysExercise ?? 0) Min")
            return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: textProvider)
        case .utilitarianLarge:
            let textProvider = CLKSimpleTextProvider(text: "\(todaysExercise ?? 0)/\(goal ?? 30) Min")
            return CLKComplicationTemplateUtilitarianLargeFlat(textProvider: textProvider)
        case .graphicCorner:
            let gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: UIColor(.accentColor), fillFraction: Float(currentFraction))
            let outerTextProvider = CLKSimpleTextProvider(text: "\(dogsName ?? "Woof")")
            return CLKComplicationTemplateGraphicCornerGaugeText(gaugeProvider: gaugeProvider, outerTextProvider: outerTextProvider)
        case .graphicBezel:
            let pawprintImage = Image("Pawprint").resizable().scaledToFit().frame(width: 20, height: 20).foregroundColor(Color.accentColor)
            let gaugeProvider = CLKSimpleGaugeProvider(style: .ring, gaugeColor: UIColor(Color.accentColor), fillFraction: Float(currentFraction))
            let circularTemplate = CLKComplicationTemplateGraphicCircularClosedGaugeView(gaugeProvider: gaugeProvider, label: pawprintImage)
            let textProvider = CLKSimpleTextProvider(text: "\(dogsName ?? "Your Dog")'s Exercise")
            return CLKComplicationTemplateGraphicBezelCircularText(circularTemplate: circularTemplate, textProvider: textProvider)
        case .graphicRectangular:
            let pawprintImage = Image("Pawprint").foregroundColor(Color.accentColor)
            let headerTextProvider = CLKSimpleTextProvider(text: "\(dogsName ?? "Your Dog")")
            let bodyTextProvider = CLKSimpleTextProvider(text: "\(todaysExercise ?? 0) Min")
            let gaugeProvider = CLKSimpleGaugeProvider(style: .ring, gaugeColor: UIColor(Color.accentColor), fillFraction: Float(currentFraction))
            return CLKComplicationTemplateGraphicRectangularTextGaugeView(headerLabel: pawprintImage, headerTextProvider: headerTextProvider, bodyTextProvider: bodyTextProvider, gaugeProvider: gaugeProvider)
        default:
            return nil
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        handler(nil)
    }
    
    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        let template = getComplicationTemplate(for: complication, using: Date())
        if let t = template {
            handler(t)
        } else {
            handler(nil)
        }
        
    }
    
}
