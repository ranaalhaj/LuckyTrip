//
//  UIStoryboardExt.swift
//  iOSTemplate
//
//  Created by OmarAltawashi on 7/16/17.
//  Copyright © 2017 UnitOne. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI


enum Storyboard : String {
    
    case main = "Main"
    case authentication = "Authentication"
    case programsPresenters = "ProgramsPresenters"
    case articles = "Articles"
    case Home = "Home"
    case Browse = "Browse"
    case LaunchScreen = "LaunchScreen"
        case SplashScreen = "SplashScreen"
    case Live = "Live"
    case MyList =  "MyList"
    case More = "More"
    case deviceManagement = "DeviceManagement"
    case AdvertiseWithUS = "AdvertiseWithUS"
    case ContactWithUs = "ContactWithUs"
    case PrivacyPolicy = "privacyPolicy"
}

extension UIStoryboard {

    static func instanceFromMain<T: UIViewController>() -> T {
        return load(from: .main, identifier: String(describing: T.self)) as! T
    }
    
    static func instanceFromAuth<T: UIViewController>() -> T {
        return load(from: .authentication, identifier: String(describing: T.self)) as! T
    }
    static func instanceFromProgramsPresenters<T: UIViewController>() -> T {
        return load(from: .programsPresenters, identifier: String(describing: T.self)) as! T
    }
    static func instanceFromArticles<T: UIViewController>() -> T {
        return load(from: .articles, identifier: String(describing: T.self)) as! T
    }
    static func instanceFromHome<T: UIViewController>() -> T {
        return load(from: .Home, identifier: String(describing: T.self)) as! T
    }
    static func instanceFromBrowse<T: UIViewController>() -> T {
        return load(from: .Browse, identifier: String(describing: T.self)) as! T
    }
    static func instanceFromLive<T: UIViewController>() -> T {
        return load(from: .Live, identifier: String(describing: T.self)) as! T
    }
    static func instanceFromMyList<T: UIViewController>() -> T {
        return load(from: .MyList, identifier: String(describing: T.self)) as! T
    }
    static func instanceFromMore<T: UIViewController>() -> T {
        return load(from: .More, identifier: String(describing: T.self)) as! T
    }
    static func loadFromMain(_ identifier: String) -> UIViewController {
        return load(from: .main, identifier: identifier)
    }

    static func loadFromHome(_ identifier: String) -> UIViewController {
        return load(from: .Home, identifier: identifier)
    }
    
    static func instanceFromDeviceManagement<T: UIViewController>() -> T {
        return load(from: .deviceManagement, identifier: String(describing: T.self)) as! T
    }
    static func loadFromMore<T: UIViewController>() -> T {
        return load(from: .More, identifier: String(describing: T.self)) as! T
    }
    static func instanceFromAdvertiseWithUS<T: UIViewController>() -> T {
        return load(from: .AdvertiseWithUS, identifier: String(describing: T.self)) as! T
    }
    static func instanceFromContactWithUs<T: UIViewController>() -> T {
        return load(from: .ContactWithUs, identifier: String(describing: T.self)) as! T
    }
    static func instanceFromPrivacyPolicy<T: UIViewController>() -> T {
        return load(from: .PrivacyPolicy, identifier: String(describing: T.self)) as! T
    }
    // optionally add convenience methods for other storyboards here ...
    
    // ... or use the main loading method directly when
    // instantiating view controller from a specific storyboard
    static func load(from storyboard: Storyboard, identifier: String) -> UIViewController {
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return uiStoryboard.instantiateViewController(withIdentifier: identifier)
    }
}
