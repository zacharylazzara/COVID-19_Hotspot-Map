//
//  ContentView.swift
//  COVID-19 Hotspot Information Extension
//
//  Created by Yuna on 2020-12-09.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    @State var threat: Double = 0.0
    
    var body: some View {
        VStack {
            Text("\(self.viewModel.currentLocality["cityName"] as? String ?? " ")")
            Text("Cases: \(self.viewModel.currentLocality["NoOfCases"] as? Int64 ?? 0)")
            Text("Threat Level: \(String(format: "%.2f", self.viewModel.currentLocality["threatLevel"] as? Double ?? 0))")
        }
            Divider()
            Text("Suggestion:")
            if ((self.viewModel.currentLocality["threatLevel"] as? Double ?? 0)>5.0){
                Text("Please be EXTREMELY careful when you are out")
            }
            if ((self.viewModel.currentLocality["threatLevel"] as? Double ?? 0)>2.0 && (self.viewModel.currentLocality["threatLevel"] as? Double ?? 0) < 5.0){
                Text("Going outside should be ok but please be careful")
            }
            if ((self.viewModel.currentLocality["threatLevel"] as? Double ?? 0) < 2.0){
                Text("Your region is safe so far! keep it up and we are this together!")
            }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
