//
//  ProvincesView.swift
//  COVID-19 Hotspot Map
//
//  Created by Yuna on 2020-12-07.
//
import SwiftUI

struct ProvincesView: View {
    @EnvironmentObject var covidViewModel: CovidViewModel
    @EnvironmentObject var navigationHelper: NavigationHelper
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    private var localities: [String: Locality] = [String: Locality]()
    private var provinces: [String] = [String]()
    
    init(localities: [String: Locality]) {
        self.localities = localities
        
        for (_ , locacity) in localities {
            if let province = locacity.province  {
                if !provinces.contains(province) {
                    provinces.append(province)
                }
            }
        }
    }
    
    var body: some View {

        VStack{
            List {
                ForEach(self.provinces, id: \.self) { province in
                    NavigationLink(destination: ProvinceCitiesView(localities: self.localities, selectedProvince: province)) {
                        Text(province)
                    }
                }
            }
        }

    }
}


