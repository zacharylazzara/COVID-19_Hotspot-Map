//
//  ProvincialSummaryView.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-24.
//

// TODO: display a summary of the COVID-19 data for this province, such as mortality percentage and other information

import SwiftUI

struct ProvincialSummaryView: View {
    var body: some View {
        Text("This will be a summary of the province's COVID-19 cases; it'll include things like the mortality rate, number of deaths, number of recovered, cumulative cases, active cases, etc; basically everything we get from the API as well as some information we determine for ourselves. Might want to include graphs to show trends and such.").padding()
        Spacer()
    }
}

struct ProvincialSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ProvincialSummaryView()
    }
}
