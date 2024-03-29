//
//  ContentView.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-21.
//
//  Group #2: Zachary Lazzara (991 349 781), Yaun Wang (991 470 659)
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var covidViewModel: CovidViewModel
    @EnvironmentObject var navigationHelper: NavigationHelper

    @State var showInfo: Bool = false
    @State var infoLoc: Locality?
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                //added addcurrent locaiton for navigating if user click on another city
                MapView(localities: covidViewModel.getLocalities(), showInfo: $showInfo, infoLoc: $infoLoc, currentLocation: $covidViewModel.currentLocation).ignoresSafeArea().actionSheet(isPresented: self.$showInfo) {
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
                        }).foregroundColor(.red)
                },
                trailing: HStack {
                    NavigationLink(destination: ProvincesView(localities: covidViewModel.getLocalities())) {
                        Image(systemName: "list.number")
                    }
                })
            .navigationBarBackButtonHidden(true)
            .onReceive(self.navigationHelper.$showRoot) { (popToRootView) in
                if popToRootView {
                    self.resetNavView()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())

    }
    func resetNavView(){
        self.$navigationHelper.showRoot.wrappedValue = false
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
