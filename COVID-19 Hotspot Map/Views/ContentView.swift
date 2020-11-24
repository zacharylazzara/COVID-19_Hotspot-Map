//
//  ContentView.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//

import SwiftUI

// TODO: in order to figure out our locality, we can just match locality with city, and failing that, we can use longitude and latitude

struct ContentView: View {
    @EnvironmentObject var covidViewModel: CovidViewModel
    
//    @State var city: City?
//    @State var cities = [City]()
    
    var body: some View {
        VStack {
            Text("\(covidViewModel.getCurrentLocality()?.name ?? "unavailable"), \(covidViewModel.getCurrentLocality()?.province ?? "unavailable")")
            Text("Active Provincial Cases: \(covidViewModel.getCurrentLocality()?.provinceCases ?? -1)")
            Text("Active Local Cases: \(covidViewModel.getCurrentLocality()?.covidCases ?? -1)")
            
//            ForEach(summaryViewModel.summary.regions, id: \.self) { region in
//                Text("Province: \(region.province)")
//                Text("New Cases: \(region.cases)")
//            }
            
            
            
            // TODO: we need to show the probability of catching COVID-19; we'll need to use the average spread rate as well as the population density for the locality
            
            
            Spacer()
        }.onAppear {
            //summaryViewModel.fetchRegionalSummary(admin: "ON", loc: "3595") // TODO: if we can get health region codes we can use this
//            covidViewModel.initializeCityData().notify(queue: .main) {
//                //city = covidViewModel.localities["Toronto"]
//                //covidViewModel.setLocality(loc: "Toronto")
//                //city = covidViewModel.locality
//            }
            //covidViewModel.setLocality(loc: "Toronto")
            //city = covidViewModel.locality
            
            // TODO: still not waiting
           //city = covidViewModel.cities[0]
            //city = cities[0]
//            covidViewModel.cities.forEach { city in
//                print(city)
//            }
            
            //city = covidViewModel.predictCasesForCity(city: covidViewModel.cities[0])
            //summaryViewModel.fetchProvincialSummary(admin: covidViewModel.cities[0].provinceId!)
            //var city2 = covidViewModel.predictCasesForCity(city: city)
            
           // print(city2)
            
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
