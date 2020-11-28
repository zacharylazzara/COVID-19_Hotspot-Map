//
//  ContentView.swift
//  COVID-19 Hotspot Information Extension
//
//  Created by Zachary Lazzara on 2020-11-26.
//

import SwiftUI

struct ContentView: View {
    //var covidViewModel = CovidViewModel()
    
    var body: some View {
        VStack {
            //Text("Estimated Local Cases: \(covidViewModel.getCurrentLocality()?.covidCases ?? 0)")
            Text("Provincial Cases: 0")
            Text("Threat Level: 0")
        }.onAppear {
//            covidViewModel.initializeCityData().notify(queue: .main) {
//                // TODO: initialize is working but we dont get a current locality
//                print(#function, covidViewModel.getCurrentLocality())
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
