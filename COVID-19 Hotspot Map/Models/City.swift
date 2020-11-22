//
//  City.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//

import Foundation

// Tutorial for this: https://www.donnywals.com/using-codable-with-core-data-and-nsmanagedobject/

class City: NSManagedObject, Decodable {
    var name: String?
    var province: String?
    var provinceId: String?
    var population: Int32?
    var density: Double?
    var lat: Double?
    var lng: Double?
    
    //init() {}
    
    enum CodingKeys: String, CodingKey {
        case city = "city"
        case name = "city_ascii"
        case province = "province_name"
        case provinceId = "province_id"
        case population = "population"
        case density = "density"
        case lat = "lat"
        case lng = "lng"
    }
    
    enum DecoderConfigurationError: Error {
        case missingManagedObjectContext
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let query = try decoder.container(keyedBy: CodingKeys.self)
        var cities = try query.nestedUnkeyedContainer(forKey: .city)
        let city = try cities.nestedContainer(keyedBy: CodingKeys.self)
        
        self.name = try city.decodeIfPresent(String.self, forKey: .name)!
        self.province = try city.decodeIfPresent(String.self, forKey: .province)!
        self.provinceId = try city.decodeIfPresent(String.self, forKey: .provinceId)!
        self.population = try city.decodeIfPresent(Int32.self, forKey: .population)!
        self.density = try city.decodeIfPresent(Double.self, forKey: .density)!
        self.lat = try city.decodeIfPresent(Double.self, forKey: .lat)!
        self.lng = try city.decodeIfPresent(Double.self, forKey: .lng)!
    }
}
