//
//  SummaryViewModel.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//

import Foundation
import CoreData
import SwiftUI
import UIKit


//class SummaryViewModel : ObservableObject, LocationDelegate {
class SummaryViewModel : ObservableObject {
    // Health codes from: https://www150.statcan.gc.ca/n1/pub/82-402-x/2011001/app-ann/app1-ann1-eng.htm
    // TODO: health region API: https://resources-covid19canada.hub.arcgis.com/datasets/exchange::statistics-canada-health-regions
    //https://opendata.arcgis.com/datasets/c57833f0b7fb482e91c5de7b7b283a3a_0.geojson
    
    // TOOD: use this API for health regions?
    //https://services1.arcgis.com/B6yKvIZqzuOr0jBR/arcgis/rest/services/Health_Regions_in_Canada/FeatureServer/0/query?where=1%3D1&outFields=HR_UID,ENGNAME,FID&returnGeometry=false&returnDistinctValues=true&outSR=4326&f=json
    
    @Published var summary = Summary()
    @Published var province = Province()
    private var location: LocationManager
    private var apiURLString: String
    
    init() {
        apiURLString = "https://api.opencovid.ca/"
        location = LocationManager()
        //location.delegate = self // Do we really need the location delegate? I suppose it might be relevant when we change regions but thats all
    }
    
    func fetchNationalSummary() {
        guard let apiURL = URL(string: apiURLString + "summary?loc=hr") else {
            print(#function, "Problem with API URL:\n\n\(apiURLString + "summary?loc=hr")\n\n")
            return
        }
        
        URLSession.shared.dataTask(with: apiURL){(data: Data?, response: URLResponse?, error: Error?) in
            if let e = error {
                print(#function, "Error \(e.localizedDescription)")
            } else {
                DispatchQueue.global().async {
                    do {
                        if let jsonData = data {
                            let decoder = JSONDecoder()
                            let decodedSummary = try decoder.decode(Summary.self, from: jsonData)
                            DispatchQueue.main.async {
                                self.summary = decodedSummary
                                print(#function, "COVID-19 Summary: \(self.summary)")
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
    }
    
    
    // TODO: use our location to get our region
    func fetchRegionalSummary(admin: String, loc: String) {
        let provincialSummary = "/summary?loc=\(loc)"
        
        
        
        // TODO: should loc=hr change to our health region, or should it be province? can we still get specific health regions in our province? Can we get health region from Apple's location services?
        guard let apiURL = URL(string: apiURLString + provincialSummary) else {
            print(#function, "Problem with API URL:\n\n\(apiURLString + provincialSummary)\n\n")
            return
        }
        
        URLSession.shared.dataTask(with: apiURL){(data: Data?, response: URLResponse?, error: Error?) in
            if let e = error {
                print(#function, "Error \(e.localizedDescription)")
            } else {
                DispatchQueue.global().async {
                    do {
                        if let jsonData = data {
                            let decoder = JSONDecoder()
                            let decodedSummary = try decoder.decode(Summary.self, from: jsonData)
                            DispatchQueue.main.async {
                                self.summary = decodedSummary
                                print(#function, "COVID-19 Summary: \(self.summary)")
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
    }
    
    
    // TODO: for province we'll need to change how we get the Summary, as some data is different
    func fetchProvincialSummary(admin: String) {
        let provincialSummary = "/summary?loc=\(admin)"
        guard let apiURL = URL(string: apiURLString + provincialSummary) else {
            print(#function, "Problem with API URL:\n\n\(apiURLString + provincialSummary)\n\n")
            return
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
                                self.province = decodedSummary
                                print(#function, "COVID-19 Summary: \(self.province)")
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
    }
}
