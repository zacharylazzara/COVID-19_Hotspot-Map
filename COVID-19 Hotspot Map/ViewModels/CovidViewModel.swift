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
    
    public let provinceDensities = [
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
    
    public let provincePopulations = [
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
    
    
    // TODO: we should save the results of this in the city entity, or better we can save the results of the prediction
    func fetchProvincialSummary(admin: String) -> Province? {
        var province: Province?
        
        let provincialSummary = "/summary?loc=\(admin)"
        guard let apiURL = URL(string: apiURLString + provincialSummary) else {
            print(#function, "Problem with API URL:\n\n\(apiURLString + provincialSummary)\n\n")
            return province
        }
        
        // TODO: is this fetching data? it returns nil but it shouldn't be. Maybe we should just get the data from elsewhere, or return in the thread?
        
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
                let cityDecoder = JSONDecoder()
                
                cityDecoder.userInfo[CodingUserInfoKey.context!] = self.persistentContainer.viewContext
                
                // TODO: does it save to CoreData automatically? or do we need to save it ourselves?
                
                //self.cities = try cityDecoder.decode([City].self, from: data)
                var decodedCities = try cityDecoder.decode([City].self, from: data)
                
                
                let provincialSummary = "/summary?prov/"
                guard let apiURL = URL(string: apiURLString + provincialSummary) else {
                    print(#function, "Problem with API URL:\n\n\(apiURLString + provincialSummary)\n\n")
                    return
                }
                URLSession.shared.dataTask(with: apiURL){(data: Data?, response: URLResponse?, error: Error?) in
                    if let e = error {
                        print(#function, "Error \(e)")
                    } else {
                        DispatchQueue.global().async {
                            do {
                                if let jsonData = data {
                                    let provincialSummaryDecoder = JSONDecoder()
                                    // TODO: province should be an array now!!!
                                    let decodedProvincialSummary = try provincialSummaryDecoder.decode(ProvincialSummary.self, from: jsonData)
                                    
                                    
                                    DispatchQueue.main.async {
                                        // TODO: data not formatted right??
                                        // TODO: do our province calculations here and put them in the city
                                        
                                        // TODO: am I being rate limited? maybe we should fetch all this data ahead of time THEN tie it into the cities!! i.e., no foreach city; we just need data on all provinces
                                        
                                        // TODO: maybe we should do this at the same time as initializing the city? perhaps we can have the city model itself call the API?
                                        decodedCities.forEach { city in
                                            let province = decodedProvincialSummary.provinces[city.province!]
                                            
                                            let provincePopulation = Int64(self.provincePopulations[city.province!]!)
                                            //let provinceDensity = self.provinceDensities[city.province!]
                                            
                                            // TODO: this prediction should take population density and the virus's rate of spread into account, but for now this will do
                                            city.covidCases = Int64(
                                                Double(city.population) / Double(provincePopulation) * Double(province?.activeCases ?? 0)
                                            )
                                            
                                            print("Predicted cases for \(city.name): \(city.covidCases)")
                                            //- Int64(city.density / (provinceDensity! > 0 ? provinceDensity! : 1))
                                            
                                            //print("City: \(city.name) Cases: \(city.covidCases)\n")
                                            
                                        }
                                        // TODO: since this all runs async we're having some problems getting the variables out
                                        self.cities = decodedCities
                                        
                                    }
                                } else {
                                    print(#function, "JSON data is empty")
                                }
                            } catch let error {
                                print(#function, "Error decoding data: \(error)")
                            }
                        }
                    }
                }.resume()
                
                // TODO: save cities to database?
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
