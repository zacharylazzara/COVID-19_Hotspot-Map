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
    var activeCases: Int
    var cumulativeCases: Int
}
