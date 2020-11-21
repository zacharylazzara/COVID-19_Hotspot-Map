//
//  Region.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//

import Foundation

struct Region: Hashable {
    var province: String
    var healthRegion: String
    var cases: Int
    var cumulativeCases: Int
    var deaths: Int
    var cumulativeDeaths: Int
    var date: Date
}
