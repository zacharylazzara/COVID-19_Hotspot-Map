//
//  Summary.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//

import Foundation

struct Summary : Decodable {
    var regions = [Region]()
    
    init() {}
    
    enum CodingKeys: String, CodingKey {
        case summary = "summary"
        case province = "province"
        case healthRegion = "health_region"
        case cases = "cases"
        case cumulativeCases = "cumulative_cases"
        case deaths = "deaths"
        case cumulativeDeaths = "cumulative_deaths"
        case date = "date"
    }
    
    init(from decoder: Decoder) throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let query = try decoder.container(keyedBy: CodingKeys.self)
        var summary = try query.nestedUnkeyedContainer(forKey: .summary)
        
        while(!summary.isAtEnd) {
            let regionSummary = try summary.nestedContainer(keyedBy: CodingKeys.self)
            let region = Region(
                province: try regionSummary.decodeIfPresent(String.self, forKey: .province)!,
                healthRegion: try regionSummary.decodeIfPresent(String.self, forKey: .healthRegion)!,
                cases: try regionSummary.decodeIfPresent(Int.self, forKey: .cases)!,
                cumulativeCases: try regionSummary.decodeIfPresent(Int.self, forKey: .cumulativeCases)!,
                deaths: try regionSummary.decodeIfPresent(Int.self, forKey: .deaths)!,
                cumulativeDeaths: try regionSummary.decodeIfPresent(Int.self, forKey: .cumulativeDeaths)!,
                date: dateFormatter.date(from: try regionSummary.decodeIfPresent(String.self, forKey: .date)!)!
            )
            regions.append(region)
        }
    }
}
