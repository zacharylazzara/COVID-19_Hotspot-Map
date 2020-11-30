//
//  ContentView.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//

import SwiftUI

// TODO: look into https://projectpandemic.concordia.ca/ and see if they have an API?
// TODO: for some regions the numbers are way off; we should get the numbers by health region instead of by province
// TODO: we should get R0 and Re from an API, and use them for our calculations

struct ContentView: View {
    @EnvironmentObject var covidViewModel: CovidViewModel
    
    @State var showInfo: Bool = false
    @State var infoLoc: Locality?
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                MapView(localities: covidViewModel.getLocalities(), showInfo: $showInfo, infoLoc: $infoLoc).ignoresSafeArea().actionSheet(isPresented: self.$showInfo) {
                    ActionSheet(title: Text("COVID-19 Information for \(infoLoc?.name ?? "N/A")"), message: Text("Population: \(infoLoc?.population ?? 0)\nPopulation Density: \(String(format:"%.2f", infoLoc?.density ?? 0))\nEstimated Threat Level: \(String(format:"%.2f", infoLoc?.threatLevel ?? 0))\nReported Provincial Cases: \(infoLoc?.provinceCases ?? 0)\nEstimated Local Cases: \(infoLoc?.covidCases ?? 0)"), buttons: [.default(Text("Dismiss"))])
                }
                VStack(alignment: .leading) {
                    Text("\(Image(systemName: "cross.fill"))\t\(covidViewModel.getCurrentLocality()?.provinceCases ?? 0)")
                    Text("\(Image(systemName: "cross.circle.fill"))\t\(covidViewModel.getCurrentLocality()?.covidCases ?? 0)")
                    Spacer()
                }.padding()
            }
            .navigationBarTitle(Text("\(covidViewModel.getCurrentLocality()?.name ?? "N/A"), \(covidViewModel.getCurrentLocality()?.province ?? "N/A")"), displayMode: .inline)
            .navigationBarItems(
                leading: HStack {
                    NavigationLink(
                        destination: ProvincialSummaryView(),
                        label: {
                            Text("\(Image(systemName: "waveform.path.ecg"))\(String(format:"%.2f", covidViewModel.getCurrentLocality()?.threatLevel ?? 0))")
                        }).foregroundColor(.red) // TODO: we should colour code this based on how it compares to all other regions
                },
                trailing: HStack {
                    // TODO: we should probably put a menu here and have the leaderboard and settings accessible via the hamburger menu, as these are unlikely to be accessed as frequently by the user
                    NavigationLink(
                        destination: LeaderboardView(),
                        label: {
                            Image(systemName: "list.number")
                        })
                    
                })
            .navigationBarBackButtonHidden(true)
        }.onAppear {
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
