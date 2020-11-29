//
//  ProvincialSummaryView.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-24.
//

// TODO: display a summary of the COVID-19 data for this province, such as mortality percentage and other information

import SwiftUI

struct ProvincialSummaryView: View {
    @EnvironmentObject var covidViewModel: CovidViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Population Information").fontWeight(.bold)
            Text("\(covidViewModel.getCurrentLocality()?.name ?? "N/A") Population:\t\t\t\t\(Image(systemName: "person.crop.circle"))\t\(covidViewModel.getCurrentLocality()?.population ?? 0)")
            Text("Population Density:\t\t\t\t\(Image(systemName: "rectangle.stack.person.crop"))\t\(String(format:"%.2f", covidViewModel.getCurrentLocality()?.density ?? 0))\n")
            
            Text("COVID-19 Information").fontWeight(.bold)
            Text("Threat Level:\t\t\t\t\t\t\(Image(systemName: "waveform.path.ecg"))\t\(String(format:"%.2f", covidViewModel.getCurrentLocality()?.threatLevel ?? 0))")
            Text("\(covidViewModel.getCurrentLocality()?.province ?? "N/A") Reported Cases:\t\t\t\(Image(systemName: "cross.fill"))\t\(covidViewModel.getCurrentLocality()?.provinceCases ?? 0)")
            
            Text("\(covidViewModel.getCurrentLocality()?.name ?? "N/A") Estimated Cases:\t\t\t\(Image(systemName: "cross.circle.fill"))\t\(covidViewModel.getCurrentLocality()?.covidCases ?? 0)")
            
        }.padding()
        
        // TODO: add trend graphs here perhaps? Also we should pull mortality data from the API and save to CoreData as well so we can access it here, so we can provide mortality information.
        
        Spacer()
        // TODO: put a link to government website or a phone number for COVID-19 help here?
    }
}

struct ProvincialSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ProvincialSummaryView()
    }
}
