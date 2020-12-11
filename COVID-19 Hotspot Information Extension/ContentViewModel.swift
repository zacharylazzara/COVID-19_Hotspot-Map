//
//  ContentViewModel.swift
//  COVID-19 Hotspot Information Extension
//
//  Created by Yuna on 2020-12-10.
//

import Foundation
import WatchConnectivity
import ClockKit

class ContentViewModel : NSObject, ObservableObject, WCSessionDelegate {
    @Published var currentLocality: [String: Any] = [:] {
        didSet {
            let server = CLKComplicationServer.sharedInstance()
            for complication in server.activeComplications ?? [] {
                server.reloadTimeline(for: complication)
            }
        }
    }
    
    let session = WCSession.default
    
    override init() {
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("received message: \(message)")
        DispatchQueue.main.async {
            self.currentLocality = message
            UserDefaults.standard.setValue(self.currentLocality["threatLevel"] as? Double ?? 0, forKey: "TL")
        }
    }
}
