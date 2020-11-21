//
//  ContentView.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var summaryViewModel: SummaryViewModel
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
            summaryViewModel.fetchProvincialSummary(admin: "ON")
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
