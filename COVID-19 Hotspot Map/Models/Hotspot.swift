//
//  Hotspot.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//

import Foundation

struct Hotspot {
    var province: Province
    var locallity: String // This will be the city or town
    var predictedCases: Int // Number of active cases we think this town has based on its population and active cases by province or health region
    var population: Int
    
    
    
}
