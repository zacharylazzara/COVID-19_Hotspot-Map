//
//  LocalAnnotation.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-24.
//
//  Group #2: Zachary Lazzara (991 349 781), Yaun Wang (991 470 659)
//

import Foundation
import MapKit

class LocalityAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var locality: Locality
    
    init(locality: Locality) {
        title = String(format: "%@, %@\t", locality.name!, locality.provinceId!)
        subtitle = String(format: "Estimated Cases: %d\t", locality.covidCases)
        self.coordinate = CLLocationCoordinate2D(latitude: locality.lat, longitude: locality.lng)
        self.locality = locality
    }
}
