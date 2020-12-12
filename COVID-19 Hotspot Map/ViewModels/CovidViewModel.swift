//
//  CovidViewModel.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//
//  Group #2: Zachary Lazzara (991 349 781), Yaun Wang (991 470 659)
//

import Foundation
import CoreData
import WatchConnectivity //added watch connectivity

class CovidViewModel : NSObject, ObservableObject, LocationDelegate, WCSessionDelegate {
    private var apiURLString = "https://api.opencovid.ca/"
    private var location: LocationManager?
    private var initialized: Bool = false
    private var moc: NSManagedObjectContext?
    
    var session: WCSession?
    
    @Published private var localities:[String:Locality] = [:] // This is a dictionary of all localities in Canada
    @Published private var currentLocality: Locality? // This is where the user is currently located
    @Published var currentLocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    init(context: NSManagedObjectContext) {
        super.init()
        moc = context
        location = LocationManager()
        initializeLocalityData().notify(queue: .main) {
            self.location?.delegate = self
            self.initialized = true
        }
        self.configureWatchKitSesstion()
    }
    
    func configureWatchKitSesstion() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func isDataInitialized() -> Bool {
        return initialized
    }
    
    func setCurrentLocality(loc: String) {
        currentLocality = localities[loc] ?? nil
        sendDataToWatch()
    }
    
    
    func getCurrentLocality() -> Locality? {
        return currentLocality
    }
    
    func getLocalities() -> [String:Locality] {
        return localities
    }
    
    //added this function to get the current location
    func setCurrentLocation(loc: CLLocationCoordinate2D) {
        currentLocation = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
    }
    
    func sendDataToWatch() {
        if let validSession = self.session, validSession.isReachable {
            let cityName = self.getCurrentLocality()?.name ?? " "
            let threatLevel = self.getCurrentLocality()?.threatLevel ?? 0
            let cases = self.getCurrentLocality()?.provinceCases ?? 0
            let data: [String: Any] = [
                "cityName": cityName,
                "threatLevel": threatLevel,
                "NoOfCases": cases
            ]
            validSession.sendMessage(data, replyHandler: nil, errorHandler: nil)
        }
    }
    
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
    
    public let covidReproductiveNumber = 1.1
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "COVID_19_Hotspot_Map")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func loadLocalityData() {
        let request = NSFetchRequest<Locality>(entityName: "Locality")
        do {
            let result = try moc?.fetch(request)
            
            for locality in result! as [Locality] {
                self.localities[locality.name!] = locality
            }
        } catch let error as NSError {
            print(#function, error.localizedDescription)
        }
    }
    
    private func registerLocalityData(locs: [Locality], decodedProvincialSummary: ProvincialSummary?) {
        if decodedProvincialSummary != nil {
            locs.forEach { locality in
                let province = decodedProvincialSummary!.provinces[locality.province!]
                let provincePopulation = Int64(self.provincePopulations[locality.province!]!)
                locality.provinceCases = Int64(province?.activeCases ?? 0)
                
                // NOTE: These are the predictions
                locality.covidCases = Int64(Double(locality.population) / Double(provincePopulation) * Double(province?.activeCases ?? 0))
                locality.threatLevel = Double(locality.covidCases) / Double(locality.population) * Double(locality.density) * self.covidReproductiveNumber
                
                self.localities[locality.name!] = locality
            }
            
            do { // Save updated infromation to CoreData
                try self.moc?.save()
            } catch {
                print(error)
            }
        } else {
            print(#function, "Unable to update COVID-19 data, using old data")
        }
    }
    
    public func initializeLocalityData() -> DispatchGroup {
        let group = DispatchGroup()
        if (initialized) {
            return group
        }
        loadLocalityData()
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
                }
                group.leave()
            }.resume()
            group.wait()
            if self.localities.isEmpty { // If we have no saved localities from CoreData load and save data from canadacities.json
                do {
                    if let url = Bundle.main.url(forResource: "canadacities", withExtension: "json") {
                        let data = try Data(contentsOf: url)
                        let cityDecoder = JSONDecoder()
                        cityDecoder.userInfo[CodingUserInfoKey.context!] = self.moc
                       self.registerLocalityData(locs: try cityDecoder.decode([Locality].self, from: data), decodedProvincialSummary: decodedProvincialSummary)
                    } else {
                        print(#function, "JSON data is empty")
                    }
                } catch let error {
                    print(#function, "Error decoding data: \(error)")
                }
            } else { // If we have localities saved in CoreData load them without reading canadacities.json
                self.registerLocalityData(locs: Array(self.localities.values.map{$0}), decodedProvincialSummary: decodedProvincialSummary)
            }
        }
        return group
    }
    #if os(iOS)
    public func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    public func sessionDidDeactivate(_ session: WCSession) {
        
    }
    #endif
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("received message: \(message)")
        DispatchQueue.main.async { //6
            if let value = message["watch"] as? String {
                print(value)
            }
        }
    }
       
}
