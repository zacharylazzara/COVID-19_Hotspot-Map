//
//  CovidViewModel.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//

import Foundation
import CoreData

// TODO: we should pull data from CoreData on initialize if it already exists, otherwise we load from JSON file

class CovidViewModel : ObservableObject, LocationDelegate {
    private var apiURLString = "https://api.opencovid.ca/"
    private var location: LocationManager
    
    @Published public var localities:[String:Locality] = [:] // TODO: make private and implement a getter
    @Published private var locality: Locality? // TODO: make private and implement a getter/setter
    
    init() {
        location = LocationManager()
        initializeCityData().notify(queue: .main) {
            self.location.delegate = self
        }
    }
    
    func setLocality(loc: String) {
        locality = localities[loc] ?? nil
    }
    
    func getLocality() -> Locality? {
        return locality
    }
    
    // TODO: we'll probably use densities (for the city not province) to determine probability of infection (it will determine danger score)
    
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
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "COVID_19_Hotspot_Map")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func initializeCityData() -> DispatchGroup {
        let group = DispatchGroup()
        
        do {
            if let url = Bundle.main.url(forResource: "canadacities", withExtension: "json") {
                let data = try Data(contentsOf: url)
                let cityDecoder = JSONDecoder()
                
                cityDecoder.userInfo[CodingUserInfoKey.context!] = self.persistentContainer.viewContext
                let decodedCities = try cityDecoder.decode([Locality].self, from: data)
                
                let provincialSummary = "/summary?prov/"
                guard let apiURL = URL(string: apiURLString + provincialSummary) else {
                    print(#function, "Problem with API URL:\n\n\(apiURLString + provincialSummary)\n\n")
                    return group
                }
                
                DispatchQueue.main.async {
                    var decodedProvincialSummary: ProvincialSummary?
                    
                    group.enter()
                    URLSession.shared.dataTask(with: apiURL){(data: Data?, response: URLResponse?, error: Error?) in
                        if let e = error {
                            print(#function, "Error \(e)")
                        } else {
                            do {
                                if let jsonData = data {
                                    let provincialSummaryDecoder = JSONDecoder()
                                    decodedProvincialSummary = try provincialSummaryDecoder.decode(ProvincialSummary.self, from: jsonData)
                                } else {
                                    print(#function, "JSON data is empty")
                                }
                            } catch let error {
                                print(#function, "Error decoding data: \(error)")
                            }
                            group.leave()
                        }
                    }.resume()
                    group.wait()
                    decodedCities.forEach { city in
                        let province = decodedProvincialSummary!.provinces[city.province!]
                        let provincePopulation = Int64(self.provincePopulations[city.province!]!)
                        city.provinceCases = Int64(province?.activeCases ?? 0)
                        
                        // NOTE: This is the prediction; we can tweak this to make the predictions better
                        city.covidCases = Int64(
                            Double(city.population) / Double(provincePopulation) * Double(province?.activeCases ?? 0)
                        )
                        
                        self.localities[city.name!] = city
                    }
                    //self.cities = decodedCities
                }
                
                // TODO: Do we need to save cities to the database or is it automatic? Also, we should make sure we overwrite data with updated date if it already exists
//                print(self.cities)
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
        
        group.notify(queue: .main) {
            print(#function, "Data initialized")
        }
        
        return group
    }
}
