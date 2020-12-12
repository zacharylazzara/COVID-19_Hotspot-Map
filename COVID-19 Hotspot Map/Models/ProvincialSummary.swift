//
//  ProvincialSummary.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-23.
//
//  Group #2: Zachary Lazzara (991 349 781), Yaun Wang (991 470 659)
//

import Foundation

struct ProvincialSummary : Decodable {
    var provinces: [String:Province] = [:]
    
    init() {}
    
    enum CodingKeys: String, CodingKey {
        case summary = "summary"
        case name = "province"
        case date = "date"
        case activeCases = "active_cases"
        case cumulativeCases = "cumulative_cases"
    }
    
    init(from decoder: Decoder) throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let query = try decoder.container(keyedBy: CodingKeys.self)
        var summary = try query.nestedUnkeyedContainer(forKey: .summary)
        
        while(!summary.isAtEnd) {
            let regionSummary = try summary.nestedContainer(keyedBy: CodingKeys.self)
            let provinceName = try regionSummary.decodeIfPresent(String.self, forKey: .name)!
            
            provinces[provinceName] = Province(
                name: provinceName,
                date: dateFormatter.date(from: try regionSummary.decodeIfPresent(String.self, forKey: .date)!)!,
                activeCases: try regionSummary.decodeIfPresent(Int.self, forKey: .activeCases)!,
                cumulativeCases: try regionSummary.decodeIfPresent(Int.self, forKey: .cumulativeCases)!
            )
        }
    }
}
