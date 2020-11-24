//
//  MapView.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-24.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @EnvironmentObject var covidViewModel: CovidViewModel
    @ObservedObject var locationManager = LocationManager()
    
    private let regionRadius: CLLocationDistance = 20000
    private var localityCoordinates: [String:CLLocationCoordinate2D] = [:]
    private var localityAnnotations: [LocalityAnnotation] = [LocalityAnnotation]()
    private var localities: [Locality] = [Locality]()
    
    init(localities: [String:Locality]) {
        for (key, locality) in localities {
            self.localityCoordinates[key] = CLLocationCoordinate2D(latitude: locality.lat, longitude: locality.lng)
            self.localityAnnotations.append(LocalityAnnotation(locality: locality))
            self.localities.append(locality)
        }
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        return MapView.Coordinator()
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let map = MKMapView()
        
        map.mapType = MKMapType.standard
        map.showsUserLocation = true
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.isUserInteractionEnabled = true
        
        let sourceCoordinates = CLLocationCoordinate2D(latitude: self.locationManager.lat, longitude: self.locationManager.lng)
        let region = MKCoordinateRegion(center: sourceCoordinates, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        map.setRegion(region, animated: true)
        map.delegate = context.coordinator
        
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        let sourceCoordinates = CLLocationCoordinate2D(latitude: self.locationManager.lat, longitude: self.locationManager.lng)
        let region = MKCoordinateRegion(center: sourceCoordinates, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        if (covidViewModel.isDataInitialized()) {
            localities.forEach { locality in
                let annotation = LocalityAnnotation(locality: locality)
                uiView.addAnnotation(annotation)
            }
        }
        
        uiView.setRegion(region, animated: true)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? LocalityAnnotation else { return nil }
            let identifier = "Locality"
            
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if (view == nil) {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view!.image = UIImage(systemName: "heart.circle") // TODO: colour code this?
                view!.canShowCallout = true
            } else {
                view!.annotation = annotation
            }
            
            return view
        }
    }
}
