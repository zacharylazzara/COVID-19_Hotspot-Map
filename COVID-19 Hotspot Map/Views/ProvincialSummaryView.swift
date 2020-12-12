//
//  ProvincialSummaryView.swift
//  COVID-19 Hotspot Map
//
//  Created by Zachary Lazzara on 2020-11-24.
//
//  Group #2: Zachary Lazzara (991 349 781), Yaun Wang (991 470 659)
//

import SwiftUI

struct ProvincialSummaryView: View {
    @EnvironmentObject var covidViewModel: CovidViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Population Information").fontWeight(.bold)
            Text("\(covidViewModel.getCurrentLocality()?.name ?? "N/A") Population:\t\t\t\t\(Image(systemName: "person.crop.circle"))\t\(covidViewModel.getCurrentLocality()?.population ?? 0)")
            Text("Population Density:\t\t\t\t\(Image(systemName: "rectangle.stack.person.crop"))\t\(String(format:"%.2f", covidViewModel.getCurrentLocality()?.density ?? 0))\n")
            
            Text("COVID-19 Statistics").fontWeight(.bold)
            Text("Estimated Threat Level:\t\t\t\(Image(systemName: "waveform.path.ecg"))\t\(String(format:"%.2f", covidViewModel.getCurrentLocality()?.threatLevel ?? 0))")
            Text("R0:\t\t\t\t\t\t\t\t\t\(Image(systemName: "arrow.3.trianglepath"))\t\(String(format:"%.2f", covidViewModel.covidReproductiveNumber))")
            Text("\(covidViewModel.getCurrentLocality()?.province ?? "N/A") Reported Cases:\t\t\t\(Image(systemName: "cross.fill"))\t\(covidViewModel.getCurrentLocality()?.provinceCases ?? 0)")
            
            Text("\(covidViewModel.getCurrentLocality()?.name ?? "N/A") Estimated Cases:\t\t\t\(Image(systemName: "cross.circle.fill"))\t\(covidViewModel.getCurrentLocality()?.covidCases ?? 0)")
        }.padding()
        Divider()
        VStack(alignment: .leading) {
            Text("Symptoms\n").fontWeight(.bold)
            // Symptom information obtained from: https://www.canada.ca/en/public-health/services/diseases/2019-novel-coronavirus-infection/symptoms.html#s
            Text("\(Image(systemName: "chevron.right.circle"))\tNew or worsening cough\n\(Image(systemName: "chevron.right.circle"))\tShortness of breath or difficulty breathing\n\(Image(systemName: "chevron.right.circle"))\tTemperature equal to or over 38°C\n\(Image(systemName: "chevron.right.circle"))\tFeeling feverish\n\(Image(systemName: "chevron.right.circle"))\tChills\n\(Image(systemName: "chevron.right.circle"))\tFatigue or weakness\n\(Image(systemName: "chevron.right.circle"))\tMuscle or body aches\n\(Image(systemName: "chevron.right.circle"))\tNew loss of smell or taste\n\(Image(systemName: "chevron.right.circle"))\tHeadache\n\(Image(systemName: "chevron.right.circle"))\tGastrointestinal symptoms\n\(Image(systemName: "chevron.right.circle"))\tFeeling very unwell")
        }.padding()
        Spacer()
        VStack(alignment: .center) {
            Image(systemName: "exclamationmark.triangle").foregroundColor(.red)
            Text("COVID-19 can spread asymptomatically").foregroundColor(.red).fontWeight(.bold)
            Text("Symptoms may take up to 14 days to appear").fontWeight(.thin)
        }.padding()
        Spacer()
    }
}

struct ProvincialSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ProvincialSummaryView()
    }
}
