//
//  Province.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//
//  Group #2: Zachary Lazzara (991 349 781), Yaun Wang (991 470 659)
//

import Foundation

struct Province: Decodable {
    var name: String
    var date: Date
    var testing: Int
    var cases: Int
    var deaths: Int
    var recovered: Int
    var activeCases: Int
    var activeCasesChange: Int
    var cumulativeCases: Int
    var cumulativeDeaths: Int
    var cumulativeRecovered: Int
    var cumulativeTesting: Int
}
