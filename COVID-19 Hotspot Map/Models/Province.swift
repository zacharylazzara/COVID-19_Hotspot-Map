//
//  Province.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//

import Foundation

struct Province: Decodable {
    var name: String
    var date: Date
    var testing: Int // Are these testing for today?
    var cases: Int // Are these cases for today?
    var deaths: Int // Are these deaths for today?
    var recovered: Int // Are these recovered for today?
    var activeCases: Int
    var activeCasesChange: Int
    var cumulativeCases: Int
    var cumulativeDeaths: Int
    var cumulativeRecovered: Int
    var cumulativeTesting: Int
    
    
    
    
    
//    init() {}
//
//    enum CodingKeys: String, CodingKey {
//        case summary = "summary"
//        case name = "province"
//        case activeCases = "active_cases"
//        case totalCases = "cumulative_cases"
//        case totalDeaths = "cumulative_deaths"
//    }
//
//    init(from decoder: Decoder) throws {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy"
//
//        let query = try decoder.container(keyedBy: CodingKeys.self)
//        var summary = try query.nestedUnkeyedContainer(forKey: .summary)
//
//        let province = try summary.nestedContainer(keyedBy: CodingKeys.self)
//        self.name = try province.decodeIfPresent(String.self, forKey: .name)
//        self.activeCases = try province.decodeIfPresent(Int.self, forKey: .activeCases)
//        self.totalCases = try province.decodeIfPresent(Int.self, forKey: .totalCases)
//        self.totalDeaths = try province.decodeIfPresent(Int.self, forKey: .totalDeaths)
//    }
}
