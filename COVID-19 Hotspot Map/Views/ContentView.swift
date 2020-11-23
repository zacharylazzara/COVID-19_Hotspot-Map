//
//  ContentView.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var summaryViewModel: SummaryViewModel
    @EnvironmentObject var covidViewModel: CovidViewModel
    
    @State var city: City?
    
    
    var body: some View {
        VStack {
            Text("Province: \(city?.province ?? "unavailable")")
           // Text("Active Provincial Cases: \(summaryViewModel.province.activeCases ?? -1)")
            Text("City: \(city?.name ?? "unavailable")")
            Text("Cases: \(city?.covidCases ?? -1)")
            
//            ForEach(summaryViewModel.summary.regions, id: \.self) { region in
//                Text("Province: \(region.province)")
//                Text("New Cases: \(region.cases)")
//            }
        }.onAppear {
            //summaryViewModel.fetchRegionalSummary(admin: "ON", loc: "3595") // TODO: if we can get health region codes we can use this
            covidViewModel.initializeCityData()
            
            
//            covidViewModel.cities.forEach { city in
//                print(city)
//            }
            
            //city = covidViewModel.predictCasesForCity(city: covidViewModel.cities[0])
            summaryViewModel.fetchProvincialSummary(admin: covidViewModel.cities[0].provinceId!)
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
