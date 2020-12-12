//
//  ProvinceCitiesView.swift
//  COVID-19 Hotspot Map
//
//  Created by Yuna on 2020-12-07.
//
//  Group #2: Zachary Lazzara (991 349 781), Yaun Wang (991 470 659)
//

import SwiftUI
import CoreLocation

struct ProvinceCitiesView: View {
    @EnvironmentObject var covidViewModel: CovidViewModel
    @EnvironmentObject var navigationHelper: NavigationHelper
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var searchText: String = ""
    
    private var localities: [String: Locality] = [String: Locality]()
    private var localityList: [Locality] = [Locality]()
    private var selectedProvince: String = ""
    
    init(localities: [String: Locality], selectedProvince: String) {
        self.localities = localities
        self.selectedProvince = selectedProvince
        
        for (_ , locacity) in localities {
            if let province = locacity.province  {
                if province == selectedProvince {
                    localityList.append(locacity)
                }
            }
        }
    }
    var body: some View {
        
        //search bar here
        VStack(spacing: 0.0) {
            SearchBarView(text: $searchText)
                .padding([.top, .bottom])
            List {
                ForEach(self.localityList.filter({ searchText.isEmpty ? true : $0.name!.contains(searchText) }), id: \.self) { locality in
                    ZStack {
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                Text("\(locality.name ?? "N/A")").fontWeight(.bold)
                                HStack {
                                    Text("Population: ")
                                    Spacer()
                                    Text("\(Image(systemName: "person.crop.circle")) \(locality.population)")
                                }
                                
                                HStack {
                                    Text("Population Density: ")
                                    Spacer()
                                    Text("\(Image(systemName: "rectangle.stack.person.crop")) \(String(format:"%.2f", locality.density))\n")
                                }
                                
                                HStack {
                                    Text("Estimated Threat Level: ")
                                    Spacer()
                                    Text("\(Image(systemName: "waveform.path.ecg")) \(String(format:"%.2f", locality.threatLevel ))")
                                }
                                
                                HStack {
                                    Text("\(locality.name ?? "N/A") Estimated Cases")
                                    Spacer()
                                    Text("\(Image(systemName: "cross.circle.fill")) \(locality.covidCases )")
                                }
                            }
                        }
                        
                        Color.white.opacity(0.01)
                            .onTapGesture {
                                covidViewModel.currentLocation = CLLocationCoordinate2D(latitude: locality.lat, longitude: locality.lng)
                                navigationHelper.showRoot = true
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                }
            }
        }
        
        .navigationTitle("Please Select or Search for a city")
    }
}
