//
//  ContentView.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject var covidViewModel: CovidViewModel
    
    var body: some View {
        ZStack{
            MapView(localities: covidViewModel.getLocalities())
                .edgesIgnoringSafeArea(.all)
                .frame(height: UIScreen.main.bounds.height)
            VStack(alignment: .leading){
                Spacer()
                Text("\(covidViewModel.getCurrentLocality()?.name ?? "unavailable"), \(covidViewModel.getCurrentLocality()?.province ?? "unavailable")")
                Text("Active Provincial Cases: \(covidViewModel.getCurrentLocality()?.provinceCases ?? -1)")
                Text("Active Local Cases: \(covidViewModel.getCurrentLocality()?.covidCases ?? -1)")
                
            }.padding(.bottom, 100)
            
            //print("\(covidViewModel.getLocalities()?["Toronto"])")
            // TODO: we need to show the probability of catching COVID-19; we'll need to use the average spread rate as well as the population density for the locality
        }
        .onAppear {
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MapView: UIViewRepresentable {
    @EnvironmentObject var covidViewModel: CovidViewModel
    //    typealias UIViewType = <#type#>
    
    @ObservedObject var locationManager = LocationManager()
    //private var location: String = ""
    //private var parkingCoordinates: CLLocationCoordinate2D
    private let regionRadius: CLLocationDistance = 20000
    
    private var localitiesCoordinates: [String:CLLocationCoordinate2D] = [:]
    
    init(localities: [String:Locality]) {
        for (key, locality) in localities {
            localitiesCoordinates[key] = CLLocationCoordinate2D(latitude: locality.lat, longitude: locality.lng)
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
        //let sourceCoordinates = CLLocationCoordinate2D(latitude: 43.642567, longitude: -79.387054)
        let sourceCoordinates = CLLocationCoordinate2D(latitude: self.locationManager.lat, longitude: self.locationManager.lng)
        let region = MKCoordinateRegion(center: sourceCoordinates, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        //locationManager.addPinToMapView(mapView: map, coordinates: sourceCoordinates, title: "You Are Here")
        
        map.setRegion(region, animated: true)
        
        map.delegate = context.coordinator
        
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        //let sourceCoordinates = CLLocationCoordinate2D(latitude: 43.642567, longitude: -79.387054)
        let sourceCoordinates = CLLocationCoordinate2D(latitude: self.locationManager.lat, longitude: self.locationManager.lng)
        let region = MKCoordinateRegion(center: sourceCoordinates, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        //locationManager.addPinToMapView(mapView: uiView, coordinates: sourceCoordinates, title: self.locationManager.address)
        
        //let destinationCoordinates = self.parkingCoordinates
        if (covidViewModel.isDataInitialized()) {
            for (key, coordinates) in localitiesCoordinates {
                self.locationManager.addPinToMapView(mapView: uiView, coordinates: coordinates, title: key)
                print(coordinates)
            }
        }
        
        
        
        uiView.setRegion(region, animated: true)
        
        // create and display directions
        
        //        let request = MKDirections.Request()
        //        request.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceCoordinates))
        //request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinates))
        //        let direction = MKDirections(request: request)
        //
        //        direction.calculate{(direct, error) in
        //            if (error != nil) {
        //                print(#function, "Error finding directions ", error?.localizedDescription as Any)
        //            }
        //            let polyline = direct?.routes.first?.polyline
        //            if (polyline != nil) {
        //                uiView.addOverlay(polyline!)
        //                uiView.setRegion(MKCoordinateRegion(polyline!.boundingMapRect), animated: true)
        //            }
        //
        //        }
        
        //we should check if source and destination are the same location; inform user if they are but don't display the route (the MKCoordinator will not provide direction in this case)
        //Check for nil values/unavailability
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 5
            return renderer
        }
    }
}

