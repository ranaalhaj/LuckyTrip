//
//  internetConnections.swift
//  Avon Sales
//

import UIKit
import Reachability
class ConnectionManager {

static let sharedInstance = ConnectionManager()
private var reachability : Reachability!

func observeReachability(){
    self.reachability = try! Reachability()
    NotificationCenter.default.addObserver(self, selector:#selector(self.reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
    do {
        try self.reachability.startNotifier()
    }
    catch(let error) {
        print("Error occured while starting reachability notifications : \(error.localizedDescription)")
    }
}

@objc func reachabilityChanged(note: Notification) {
    let reachability = note.object as! Reachability
    switch reachability.connection {
    case .cellular:
        print("Network available via Cellular Data.")
        isConnected = true
        break
    case .wifi:
        isConnected = true
        print("Network available via WiFi.")
        break
    case .none:
        isConnected = false
        print("Network is not available.")
        
        break
    case .unavailable:
        isConnected = false
        print("Network is unavailable.")
        /// TO DO Display swift messages ‘Please Check your connection‘
        Utl.ShowNotfication(Status: "Failed", Body: "check_your_internet_connection".localized)
    }
}
}

