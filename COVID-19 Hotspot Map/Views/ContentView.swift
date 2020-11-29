//
//  ContentView.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//

import SwiftUI

// TODO: look into https://projectpandemic.concordia.ca/ and see if they have an API?
// TODO: for some regions the numbers are way off; we should get the numbers by health region instead of by province


struct ContentView: View {
    @EnvironmentObject var covidViewModel: CovidViewModel
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                MapView(localities: covidViewModel.getLocalities()).ignoresSafeArea()
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
