//
//  City.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//

import Foundation
import CoreData

class City: NSManagedObject, Decodable {
    private enum CodingKeys: String, CodingKey {
        case name = "city_ascii"
        case province = "province_name"
        case provinceId = "province_id"
        case population = "population"
        case density = "density"
        case lat = "lat"
        case lng = "lng"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = CodingUserInfoKey.context,
              let moc = decoder.userInfo[context] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "Locality", in: moc)
        else {
            fatalError("Couldn't get context")
        }
        
        self.init(entity: entity, insertInto: moc)
        let city = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try city.decodeIfPresent(String.self, forKey: .name)!
        self.province = try city.decodeIfPresent(String.self, forKey: .province)!
        self.provinceId = try city.decodeIfPresent(String.self, forKey: .provinceId)!
        self.population = try city.decodeIfPresent(Int64.self, forKey: .population)!
        self.density = try city.decodeIfPresent(Double.self, forKey: .density)!
        self.lat = Double(try city.decodeIfPresent(String.self, forKey: .lat)!)!
        self.lng = Double(try city.decodeIfPresent(String.self, forKey: .lng)!)!
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
