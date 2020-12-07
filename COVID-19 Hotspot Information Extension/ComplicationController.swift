//
//  ComplicationController.swift
//  COVID-19 Hotspot Information Extension
//
//  Created by Zachary Lazzara on 2020-11-26.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "COVID-19 Hotspot Map", supportedFamilies: CLKComplicationFamily.allCases)
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
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        //let covidViewModel = CovidViewModel()
//        covidViewModel.initializeCityData()
//        let localCases = CLKSimpleTextProvider(text: String(covidViewModel.getCurrentLocality()?.covidCases ?? 0))
        
        
        
//        let minValue = CLKSimpleTextProvider(text: "0")
//        let maxValue = CLKSimpleTextProvider(text: "59")
        let gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColors: [.red, .yellow, .green], gaugeColorLocations: [0.0, 0.5, 0.7], fillFraction: 0.7)
        
        //let template = CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText(gaugeProvider: gaugeProvider, bottomTextProvider: localCases, centerTextProvider: localCases)
        
        let entries = [CLKComplicationTimelineEntry]()
        //entries.append(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        handler(entries.first)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        handler(nil)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
}
