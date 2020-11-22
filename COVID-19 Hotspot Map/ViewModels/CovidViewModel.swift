//
//  CovidViewModel.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//

import Foundation
import CoreData

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
    private var apiURLString = "https://api.opencovid.ca/"
    @Published public var cities = [City]()
    
    // TODO: we should save the results of this in the city entity, or better we can save the results of the prediction
    func fetchProvincialSummary(admin: String) -> Province? {
        var province: Province?
        
        let provincialSummary = "/summary?loc=\(admin)"
        guard let apiURL = URL(string: apiURLString + provincialSummary) else {
            print(#function, "Problem with API URL:\n\n\(apiURLString + provincialSummary)\n\n")
            return province
        }
        
        URLSession.shared.dataTask(with: apiURL){(data: Data?, response: URLResponse?, error: Error?) in
            if let e = error {
                print(#function, "Error \(e.localizedDescription)")
            } else {
                DispatchQueue.global().async {
                    do {
                        if let jsonData = data {
                            let decoder = JSONDecoder()
                            let decodedSummary = try decoder.decode(Province.self, from: jsonData)
                            DispatchQueue.main.async {
                                province = decodedSummary
                            }
                        } else {
                            print(#function, "JSON data is empty")
                        }
                    } catch let error {
                        print(#function, "Error decoding data: \(error.localizedDescription)")
                    }
                }
            }
        }.resume()
        return province
    }
    
    
    // TODO: Use this one in the heatmap; it will return an array of hotspots for a given provience
    // NOTE: COVID-19 has a Re of 1.1 (effective reproduction number); it's the average number of people one person with COVID-19 will infect; we need to use this in our predictions and other data
    func predictCasesForCity(city: City) -> City {
        var province = fetchProvincialSummary(admin: city.provinceId!)
        
        // Population Data Sources for Provinces
        // Population by Province: https://www.worldatlas.com/articles/canadian-provinces-and-territories-by-population.html
        // Density by Province: https://www.worldatlas.com/articles/canadian-provinces-and-territories-by-population-density.html
        let provinceDensities = [
            "Prince Edward Island": 24.7,
            "Nova Scotia": 17.4,
            "Ontario": 14.1,
            "New Brunswick": 10.5,
            "Quebec": 5.8,
            "Alberta": 5.7,
            "British Columbia": 4.8,
            "Manitoba": 2.2,
            "Saskatchewan": 1.8,
            "Newfoundland and Labrador": 1.4,
            "Yukon": 0.1,
            "Northwest Territories": 0,
            "Nunavut": 0
        ]
        
        // TODO: we should build these numbers from our JSON data, as we have population numbers for each city tied to their provinces; if we sum that up we can get numbers more in line with our data (but for now this is easier)
        let provincePopulations = [
            "Prince Edward Island": 142907,
            "Nova Scotia": 923598,
            "Ontario": 12851821,
            "New Brunswick": 747101,
            "Quebec": 8164361,
            "Alberta": 4067175,
            "British Columbia": 4648055,
            "Manitoba": 1278365,
            "Saskatchewan": 1098352,
            "Newfoundland and Labrador": 519716,
            "Yukon": 35874,
            "Northwest Territories": 41786,
            "Nunavut": 35944
        ]
        
        let provincePopulation = Int64(provincePopulations[city.province!]!)
        let provinceDensity = provinceDensities[city.province!]
        var City = city
//
//        let provincePopulation = Int64(provincePopulations[city.province!]!)
//        let provinceDensity = Int64(provinceDensities[city.province!]!)
//
        // This is our prediction; it's fairly accurate when tested against Toronto but seems less accurate tested against Oakville; more testing and tweaking is needed
        //city.covidCases = city.population / provincePopulation * Int64(province!.activeCases!) - Int64(city.density) / provinceDensity
        city.covidCases = city.population / provincePopulation * Int64(province!.activeCases!) - Int64(city.density / provinceDensity!)
        return city
        //city.covidCases = city.population / province.population * province?.activeCases // This is our prediction, it seems fairly accurate!
        //city.covidCases = city.population / provincePopulations[city.province] * province?.activeCases - city.density/provinceDensities[city.province] // more accurate predictor!
        
        //city.covidCases = province?.activeCases / city.population
        
        
        // TODO: probably need to get the ratio of people in Toronto vs Ontario first!!
        
        
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

//        cities.forEach { city in
//            city.covidCases = province.activeCases / city.population // TODO: tie density into this, maybe multiply by density?
//
//
////            var hotspot = Hotspot()
////            hotspot.predictedCases = province.activeCases / city.population
////            hotspots.append(hotspot)
//        }
        
        
        // TODO: we'll figure out which city we're closest to using the latlng of the city and our current latlng?
        // Maybe we should save the predicted numbers to the City entity so we don't need to retrieve them so often!
        
        
        //return [Hotspot]()
    }
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "COVID_19_Hotspot_Map")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func initializeCityData() {
        do {
            if let url = Bundle.main.url(forResource: "canadacities", withExtension: "json") {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()

                decoder.userInfo[CodingUserInfoKey.context!] = self.persistentContainer.viewContext

                // TODO: does it save automatically? or do we need to save it ourselves?
                self.cities = try decoder.decode([City].self, from: data)
                
                //print(self.cities)
//                do {
//                    try self.persistentContainer.viewContext.save()
//                } catch {
//                    print(error)
//                }
            } else {
                print(#function, "JSON data is empty")
            }
        } catch let error {
            print(#function, "Error decoding data: \(error)")
        }
    }
}
