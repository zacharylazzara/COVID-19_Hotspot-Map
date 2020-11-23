//
//  LocationManager.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//

// Toronto Coordinates: 43.6532, -79.3832

import Foundation
import CoreLocation

protocol LocationDelegate {
    func setLocality(loc: String)
}

class LocationManager: NSObject {
    private let manager = CLLocationManager()
    
    var delegate:LocationDelegate?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func start() {
        manager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            manager.startUpdatingLocation()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            manager.requestLocation()
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            manager.requestLocation()
            break
        case .restricted:
            break
        case .denied:
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, "error \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var lat: Double?
        var lng: Double?
        
        if locations.last != nil {
            lat = (locations.last!.coordinate.latitude)
            lng = (locations.last!.coordinate.longitude)
        }
        
        lat = (manager.location?.coordinate.latitude)
        lng = (manager.location?.coordinate.longitude)
        
        
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat ?? 0, longitude: lng ?? 0)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            let loc = placemarks?[0].locality // City
            let admin = placemarks?[0].administrativeArea // Province
            
            print(#function, "Lat: \(lat ?? 0), Lng: \(lng ?? 0)")
            print(#function, "Loc: \(loc ?? ""), Admin: \(admin ?? "")")
            print(#function, "Placemarks: \(placemarks)")
            
            self.delegate?.setLocality(loc: loc ?? "unavailable")
        })
    }
}
