//
//  LocationManager.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//

// Toronto Coordinates: 43.6532, -79.3832

import Foundation
import CoreLocation
import MapKit

protocol LocationDelegate {
    func setCurrentLocality(loc: String)
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
//        var lat: Double?
//        var lng: Double?
        
        if locations.last != nil {
            lat = (locations.last!.coordinate.latitude)
            lng = (locations.last!.coordinate.longitude)
        }
        
        lat = (manager.location?.coordinate.latitude) ?? 0
        lng = (manager.location?.coordinate.longitude) ?? 0
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat , longitude: lng )
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            let loc = placemarks?[0].locality
            self.delegate?.setCurrentLocality(loc: loc ?? "unavailable")
        })
    }
    
    func addPinToMapView(mapView: MKMapView, coordinates: CLLocationCoordinate2D, title: String?) {
        let mapAnnotation = MKPointAnnotation()
        mapAnnotation.coordinate = coordinates
        
        mapAnnotation.title = title
        
        mapView.addAnnotation(mapAnnotation)
    }
}
