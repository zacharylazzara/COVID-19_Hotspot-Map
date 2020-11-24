//
//  LocalAnnotation.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-24.
//

import Foundation
import MapKit

class LocalityAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(locality: Locality) {
        title = String(format: "%@, %@", locality.name!, locality.provinceId!)
        subtitle = String(format: "COVID-19 Cases: %d", locality.covidCases, locality.riskScore)
        self.coordinate = CLLocationCoordinate2D(latitude: locality.lat, longitude: locality.lng)
    }
}
