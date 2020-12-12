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
        case testing = "testing"
        case cases = "cases"
        case deaths = "deaths"
        case recovered = "recovered"
        case activeCases = "active_cases"
        case activeCasesChange = "active_cases_change"
        case cumulativeCases = "cumulative_cases"
        case cumulativeDeaths = "cumulative_deaths"
        case cumulativeRecovered = "cumulative_recovered"
        case cumulativeTesting = "cumulative_testing"
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
                testing: 0,//try regionSummary.decodeIfPresent(Int.self, forKey: .testing)!,
                cases: 0,//try regionSummary.decodeIfPresent(Int.self, forKey: .cases)!,
                deaths: 0,//try regionSummary.decodeIfPresent(Int.self, forKey: .deaths)!,
                recovered: 0,//try regionSummary.decodeIfPresent(Int.self, forKey: .recovered)!,
                activeCases: try regionSummary.decodeIfPresent(Int.self, forKey: .activeCases)!,
                activeCasesChange: 0,//try regionSummary.decodeIfPresent(Int.self, forKey: .activeCasesChange)!,
                cumulativeCases: try regionSummary.decodeIfPresent(Int.self, forKey: .cumulativeCases)!,
                cumulativeDeaths: 0,//try regionSummary.decodeIfPresent(Int.self, forKey: .cumulativeDeaths)!,
                cumulativeRecovered: 0,//try regionSummary.decodeIfPresent(Int.self, forKey: .cumulativeRecovered)!,
                cumulativeTesting: 0//try regionSummary.decodeIfPresent(Int.self, forKey: .cumulativeTesting)!
            )
        }
    }
}
