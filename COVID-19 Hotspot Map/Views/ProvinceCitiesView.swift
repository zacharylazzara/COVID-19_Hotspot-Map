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
}
