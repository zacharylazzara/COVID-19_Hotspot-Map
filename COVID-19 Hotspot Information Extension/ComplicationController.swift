//
//  ComplicationController.swift
//  COVID-19 Hotspot Information Extension
//
//  Created by Yuna on 2020-12-09.
//


import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "COVID", supportedFamilies: CLKComplicationFamily.allCases)
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        if let template = getComplicationTemplate(for: complication, using: Date()) {
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        } else {
            handler(nil)
        }
    }
    
    func getComplicationTemplate(for complication: CLKComplication, using date: Date) -> CLKComplicationTemplate? {
        switch complication.family {
        case .modularLarge:
            return createModularLargeTemplate(forDate: date)
        default:
            return nil
        }
    }
    
    private func createModularLargeTemplate(forDate date: Date) -> CLKComplicationTemplate {
        let header = CLKSimpleTextProvider(text: "Threat Level")
        let Body1 = CLKSimpleTextProvider(text: "\(String(format: "%.2f", UserDefaults.standard.value(forKey: "TL") as? Double ?? 0))")
        var Body2 = CLKSimpleTextProvider(text: "")
        if ((UserDefaults.standard.value(forKey: "TL") as? Double ?? 0) > 5){
            Body2 = CLKSimpleTextProvider(text: "Dangerous")
        }
        if ((UserDefaults.standard.value(forKey: "TL") as? Double ?? 0) < 5 && (UserDefaults.standard.value(forKey: "TL") as? Double ?? 0) > 2){
            Body2 = CLKSimpleTextProvider(text: "Safe but be careful")
        }
        if ((UserDefaults.standard.value(forKey: "TL") as? Double ?? 0) < 2){
            Body2 = CLKSimpleTextProvider(text: "Safe")
        }
       
        let template = CLKComplicationTemplateModularLargeStandardBody(headerTextProvider: header, body1TextProvider: Body1, body2TextProvider: Body2)
        
        return template
    }
    
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        let template = getComplicationTemplate(for: complication, using: Date())
        if let t = template {
            handler(t)
        } else {
            handler(nil)
        }
    }
}


