//
//  MapView.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-24.
//
//  Group #2: Zachary Lazzara (991 349 781), Yaun Wang (991 470 659)
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
    
    @Binding var showInfo: Bool
    @Binding var infoLoc: Locality?
    @Binding var currentLocation : CLLocationCoordinate2D

    
    //edited the signature to include current location
    init(localities: [String:Locality], showInfo: Binding<Bool>, infoLoc: Binding<Locality?>, currentLocation: Binding<CLLocationCoordinate2D>) {
        self._showInfo = showInfo
        self._infoLoc = infoLoc
        self._currentLocation = currentLocation
        for (key, locality) in localities {
            self.localityCoordinates[key] = CLLocationCoordinate2D(latitude: locality.lat, longitude: locality.lng)
            self.localityAnnotations.append(LocalityAnnotation(locality: locality))
            self.localities.append(locality)
        }
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        return MapView.Coordinator(showInfo: self.$showInfo, infoLoc: self.$infoLoc, currentLocation: $currentLocation)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let map = MKMapView()
        
        map.mapType = MKMapType.standard
        map.showsUserLocation = true
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.isUserInteractionEnabled = true
        
        let sourceCoordinates = CLLocationCoordinate2D(latitude: self.currentLocation.latitude, longitude: self.currentLocation.longitude)
        let region = MKCoordinateRegion(center: sourceCoordinates, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        map.setRegion(region, animated: true)
        map.delegate = context.coordinator
        
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        let sourceCoordinates = CLLocationCoordinate2D(latitude: self.currentLocation.latitude, longitude: self.currentLocation.longitude)
        let region = MKCoordinateRegion(center: sourceCoordinates, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        if (covidViewModel.isDataInitialized()) {
            localities.forEach { locality in
                let localityAnnotation = LocalityAnnotation(locality: locality)
                uiView.addAnnotation(localityAnnotation)
            }
        }
        
        uiView.setRegion(region, animated: true)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        @Binding var showInfo: Bool
        @Binding var infoLoc: Locality?
        @Binding var currentLocation : CLLocationCoordinate2D
        
        init(showInfo: Binding<Bool>, infoLoc: Binding<Locality?>, currentLocation: Binding<CLLocationCoordinate2D>) {
            self._showInfo = showInfo
            self._infoLoc = infoLoc
            self._currentLocation = currentLocation
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                if overlay is MKCircle {
                    let renderer = MKCircleRenderer(overlay: overlay)
                    let color: UIColor = .white
                    renderer.fillColor = color.withAlphaComponent(0.2)
                    renderer.lineWidth = 2.0
                    return renderer
                } else {
                    return MKPolylineRenderer()
                }
            }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? LocalityAnnotation else { return nil }
            let identifier = "Locality"
            
            var localityPlacemark = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if (localityPlacemark == nil) {
                localityPlacemark = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                localityPlacemark!.image = UIImage(systemName: "cross.circle.fill")
                localityPlacemark!.canShowCallout = true
                localityPlacemark!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                localityPlacemark?.annotation = annotation
            }
            
            return localityPlacemark
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let localityPlacemark = view.annotation as? LocalityAnnotation else { return }
            self.showInfo.toggle()
            self.infoLoc = localityPlacemark.locality
        }
    }
}
