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
    var body: some View {
        VStack {
            Text("Province: \(summaryViewModel.province.name ?? "unavailable")")
            Text("Active Cases: \(summaryViewModel.province.activeCases ?? -1)")
            
//            ForEach(summaryViewModel.summary.regions, id: \.self) { region in
//                Text("Province: \(region.province)")
//                Text("New Cases: \(region.cases)")
//            }
        }.onAppear {
            //summaryViewModel.fetchRegionalSummary(admin: "ON", loc: "3595")
            covidViewModel.initializeCityData()
            
            
//            covidViewModel.cities.forEach { city in
//                print(city)
//            }
            
            summaryViewModel.fetchProvincialSummary(admin: "ON")
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
