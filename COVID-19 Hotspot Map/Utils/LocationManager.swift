//
//  LocationManager.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//

import Foundation
import CoreLocation
import MapKit

protocol LocationDelegate {
    func setCurrentLocality(loc: String)
}

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    
    // Set to Sheridan College Trafalgar as default coordinates? (doesn't seem to work consistently; will implement later)
    @Published public var lat: Double = 0// 43.4684
    @Published public var lng: Double = 0// -79.6991
    
    public var delegate:LocationDelegate?
    
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
        case .authorizedAlways:
            manager.requestLocation()
            break;
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            manager.requestAlwaysAuthorization()
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
//        var lat: Double?
//        var lng: Double?
        
        if locations.last != nil {
            lat = (locations.last!.coordinate.latitude)
            lng = (locations.last!.coordinate.longitude)
        }
        
        lat = (manager.location?.coordinate.latitude) ?? 0
        lng = (manager.location?.coordinate.longitude) ?? 0
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: lng)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            let loc = placemarks?[0].locality
            self.delegate?.setCurrentLocality(loc: loc ?? "unavailable")
        })
    }
}
