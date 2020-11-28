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
            ZStack {
                MapView(localities: covidViewModel.getLocalities())
                    .edgesIgnoringSafeArea(.all)
                    .frame(height: UIScreen.main.bounds.height)
                VStack(alignment: .leading){
                    Spacer()
                    

                    // TODO: right align numbers
                    HStack{
                        Text("Provincial Cases:\t\t\t")
                        Text("\(covidViewModel.getCurrentLocality()?.provinceCases ?? 0)") // right align this
                    }
                    HStack{
                        Text("Estimated Local Cases:\t")
                        Text("\(covidViewModel.getCurrentLocality()?.covidCases ?? 0)") // right align this
                    }
                }.padding(.bottom, 90)
            }
            .navigationBarTitle(Text("\(covidViewModel.getCurrentLocality()?.name ?? "Unknown"), \(covidViewModel.getCurrentLocality()?.province ?? "Unknown")"), displayMode: .inline)
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
