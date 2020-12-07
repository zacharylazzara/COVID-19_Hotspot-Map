//
//  ProvinceCitiesView.swift
//  COVID-19 Hotspot Map
//
//  Created by Yuna on 2020-12-07.
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
}
