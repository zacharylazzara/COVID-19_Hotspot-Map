//
//  CovidViewModel.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//

import Foundation

// TODO: this view model needs to calculate the danger based on the active cases and population of each region
// TODO: this view model will also be the data provider to the heat map


/*
 TODO:
 - Get population data for province from sql database or csv file
 - Get cities from that province and their associated populations
 - Divide active cases based on population data and probability of spread
 
 We basically want to make assumptions about which regions are hotspots based on how many people live there and the likelyhood of COVID-19 spreading as a result of the number of people. We will divide the number of active cases among every city in the province and then from there we find the probability of getting the virus by dividing city cases by population? That gives us an estimate as to the proportion of infected people.
 
 
 */

class CovidViewModel : ObservableObject {
    
    // TODO: Use this one in the heatmap; it will return an array of hotspots for a givenprovience
    func predictHotspots(province: Province) -> [Hotspot] {
        
        
        
        return [Hotspot]()
    }
    
    
    
}
