//
//  Constant.swift
//
//  Created by Rana Alhaj on 14/8/22.
//  Copyright © 2022 ranaalhaj. All rights reserved.
//


import Foundation
import UIKit
//import Kingfisher
import SystemConfiguration
import CoreTelephony

let Utl = Utilities()
var Success = "Success"
var Failed = "Failed"
let Show = "Show"
let Hide = "Hide"
var isConnected: Bool = false
let _userDefaults = UserDefaults.standard
public typealias ProductIdentifier = String

func setLabelFromDate(_ date: Date) -> String {
    let df = DateFormatter()
    df.dateFormat = "HH:mm"
    df.amSymbol = ""
    df.pmSymbol = ""
    
    return df.string(from: date)
}

struct EConstant {
    
    struct EDateFormatter {
        static let Default: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            return dateFormatter
        }()
        static let OnlyDate: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter
        }()
        static let OnlyTime: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            return dateFormatter
        }()
        static let FacebookBirthday: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter
        }()
    }
}

func isConnectedToNetworkConstant() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)

    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return false
    }

    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }

    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)

    return (isReachable && !needsConnection)
}

