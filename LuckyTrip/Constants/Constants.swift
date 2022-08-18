//
//  Constants.swift
//  LuckyTrip
//
//  Created by Rana Alhaj on 17/08/2022.
//  This class contains all constant values

import UIKit

class Constants {
    
    struct StoryBoards {
        static let Main = "Main"
    }
    
    struct Links {
        static var MAIN_DOMAIN = "https://devapi.luckytrip.co.uk/"
        static var BASIC_URL = MAIN_DOMAIN + "api/2.0/test/"
        static let DESTINATIONS_API = "\(BASIC_URL)destinations"
    }
    
    
    
    struct Colors {
        static let darkRed = UIColor(red: 179/255, green: 0/255, blue: 22/255, alpha: 1.0)
        static let lightGray = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1.0)
    }
    
    struct cellIdentifiers {
        static let DESTINATIONCELLID = "DestinationCell"
        
    }
    
    struct strings {
        static let DEF_SEARCH_TYPE = "updateMain"
        static let Show = "Show"
        static let Hide = "Hide"
    }
    
    struct observer {
        
    }
    
    struct sizes {
      
        
    }
    
    struct numbers {
        static let MIN_ITEMS_TO_SAVE : Int = 3
        static let ACS_TAG : Int = 100
        static let DES_TAG : Int = 200
        
    }

    
    
}
