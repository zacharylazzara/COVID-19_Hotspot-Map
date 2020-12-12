//
//  LocationManager.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//
//  Group #2: Zachary Lazzara (991 349 781), Yaun Wang (991 470 659)
//

import Foundation
import CoreLocation
import MapKit

protocol LocationDelegate {
    func setCurrentLocality(loc: String)
    func setCurrentLocation(loc: CLLocationCoordinate2D)
}

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    
    @Published public var lat: Double = 0
    @Published public var lng: Double = 0
    
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
            self.delegate?.setCurrentLocation(loc: location.coordinate)
        })
    }
}
