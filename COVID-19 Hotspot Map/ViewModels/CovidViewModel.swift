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
    
    // TODO: Use this one in the heatmap; it will return an array of hotspots for a given provience
    func predictHotspots(province: Province) -> [Hotspot] {
        /* TODO:
         - Get active cases from province
         - Get population data for province from SQL or CSV file (or another API if possible)
         - Divide active cases among each city in the province by population
         
         Note: We'll probably want to take population density into account as well, as it will determine how likely any given person is to bump into someone infected
         */
        
        // TODO: use this table? https://www150.statcan.gc.ca/t1/tbl1/en/cv.action?pid=1710013501
        //https://www12.statcan.gc.ca/wds-sdw/cpr2016-eng.cfm
        
//        let cities = [City]() // TODO: we need to get city data from a database; maybe we'll do that here rather than in a model?
//
//        var hotspots = [Hotspot]()
//
//        cities.forEach { city in
//            var hotspot = Hotspot()
//            hotspot.predictedCases = province.activeCases / city.population
//            hotspots.append(hotspot)
//        }
        
        
        return [Hotspot]()
    }
    
    
    
    
    
    func initializeCityData() {
        var city = City()
        
        
        // follow this tutorial https://www.donnywals.com/using-codable-with-core-data-and-nsmanagedobject/
        DispatchQueue.global().async {
            do {
                if let jsonData = Bundle.main.path(forResource: "canadacities", ofType: "json") {
                    let decoder = JSONDecoder()
                    let decodedSummary = try decoder.decode(City.self, from: jsonData)
                    DispatchQueue.main.async {
                        self.summary = decodedSummary
                        print(#function, "COVID-19 Summary: \(self)")
                    }
                } else {
                    print(#function, "JSON data is empty")
                }
            } catch let error {
                print(#function, "Error decoding data: \(error.localizedDescription)")
            }
        }
    }
    
    
}
