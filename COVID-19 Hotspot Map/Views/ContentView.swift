//
//  ContentView.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//

import SwiftUI


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
                        Text("Active Provincial Cases:\t")
                        Text("\(covidViewModel.getCurrentLocality()?.provinceCases ?? -1)") // right align this
                    }
                    HStack{
                        Text("Predicted Local Cases:\t")
                        Text("\(covidViewModel.getCurrentLocality()?.covidCases ?? -1)") // right align this
                    }
                }.padding(.bottom, 90)
            }
            .navigationBarTitle(Text("\(covidViewModel.getCurrentLocality()?.name ?? "Unknown"), \(covidViewModel.getCurrentLocality()?.province ?? "Unknown")"), displayMode: .inline)
            .navigationBarItems(
                leading: HStack {
                    NavigationLink(
                        destination: ProvincialSummaryView(),
                        label: {
                            Text("\(Image(systemName: "waveform.path.ecg"))\(String(format:"%.2f", covidViewModel.getCurrentLocality()?.riskScore ?? -1))")
                        }).foregroundColor(.red) // TODO: we should colour code this based on how it compares to all other regions
                },
                trailing: HStack {
                    // TODO: we should probably put a menu here and have the leaderboard and settings accessible via the hamburger menu, as these are unlikely to be accessed as frequently by the user
                    NavigationLink(
                        destination: LeaderboardView(),
                        label: {
                            Image(systemName: "thermometer")
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
