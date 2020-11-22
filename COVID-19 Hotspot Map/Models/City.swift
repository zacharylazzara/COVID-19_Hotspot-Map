//
//  City.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//

import Foundation
import CoreData

// Tutorial for this: https://www.donnywals.com/using-codable-with-core-data-and-nsmanagedobject/

class City: NSManagedObject, Decodable {
//    var name: String?
//    var province: String?
//    var provinceId: String?
//    var population: Int32?
//    var density: Double?
//    var lat: Double?
//    var lng: Double?
    
    //init() {}
    
    private enum CodingKeys: String, CodingKey {
        //case city = "cities"
        case name = "city_ascii"
        case province = "province_name"
        case provinceId = "province_id"
        case population = "population"
        case density = "density"
        case lat = "lat"
        case lng = "lng"
    }
    
    required convenience public init(from decoder: Decoder) throws {
//        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
//            throw DecoderConfigurationError.missingManagedObjectContext
//        }
//        guard let contextUserInfoKey = CodingUserInfoKey(rawValue: "context") else {fatalError()}
//        guard let moc = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else {fatalError()}
//        guard let entity = NSEntityDescription.entity(forEntityName: "Article", in: moc) else {fatalError()}
//
//        self.init(entity: entity, insertInto: nil)
        
        guard let context = CodingUserInfoKey.context,
              let moc = decoder.userInfo[context] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "City", in: moc)
        else {
            fatalError("Couldn't get context")
        }
        
        self.init(entity: entity, insertInto: moc)
        
        //self.init(context: context)
        
//        let query = try decoder.container(keyedBy: CodingKeys.self)
//        var cities = try query.nestedUnkeyedContainer(forKey: .city)
//        let city = try cities.nestedContainer(keyedBy: CodingKeys.self)
        let city = try decoder.container(keyedBy: CodingKeys.self)
        
        //let city = try query.nestedUnkeyedContainer(forKey: CodingKeys.self)
        
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

//extension JSONDecoder {
//    convenience init(context: NSManagedObjectContext) {
//        self.init()
//        self.userInfo[.context] = context
//    }
//}
//https://cocoacasts.com/setting-up-the-core-data-stack-with-nspersistentcontainer

//let context = CoreDataStack.store.persistentContainer.newBackgroundContext() //Getting context
//let plistDecoderForArticle = PropertyListDecoder()
//plistDecoderForArticle.userInfo[CodingUserInfoKey.context!] = context //Pass it to CodingUserInfoKey which is made for that
//let decodedData = try plistDecoderForArticle.decode([Article].self, from: data) //Decoding init got the managedObjectContext
