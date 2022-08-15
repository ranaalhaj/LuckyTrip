//
//  APIConstants.swift
//  UnitOneTemplate
//
//  Created by Ahmed Qazzaz on 6/9/20.
//  Copyright © 2020 unitone. All rights reserved.
//

import Foundation
/*This is a Tamplate class*/

// Typealias for callback functions signatures

typealias ERROR_CALLBACK_HANDLER = (_ error : NSError?)->Void
typealias SUCCESS_CALLBACK_HANDLER<T> = (_ data : T?)->Void

// End of typealias


//API enum used to save all your APIs
enum API : String{
    private var basicURL : URL {
        return URL(string: "https://roya22.roya.tv/api/v01/")!
    }
    static var basicURL_test : URL{
        return URL(string: "")!
    }
    
    var url : URL {
        return basicURL.appendingPathComponent(self.rawValue)
    }

    func urlforUser(userType:UserTypeAPI)->URL {
        let link = userType.rawValue + self.rawValue
        return basicURL.appendingPathComponent(link)
    }
    
    func urlWithId(_ id : String) -> URL {
        let url = basicURL.appendingPathComponent(self.rawValue.replacingOccurrences(of: "{id}", with: id))
        return url
    }
        
    case login = "user/login"
    case talentsList = "talents-list"
    case talentDetails = "talent/{id}"
    case servicesList = "services-list"
    case interestsList = "interests-list"
}

enum UserTypeAPI: String{
    case sales = "sales/"
    case customer = "customer/"
}

