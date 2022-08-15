//
//  APIConstants.swift
//
//  Created by Rana Alhaj on 14/8/22.
//  Copyright © 2022 ranaalhaj. All rights reserved.
//


import Foundation

typealias ERROR_CALLBACK_HANDLER = (_ error : NSError?)->Void
typealias ERROR_CALLBACK_HANDLER_WITH_ERROR<T> = (_ error : NSError?, _ data : T?)->Void
typealias SUCCESS_CALLBACK_HANDLER<T> = (_ data : T?)->Void
typealias NetworkRouterCompletion = (_ responseData: (Any)? , _ error: String?)->()


enum API : String{
    private var basicURL : URL {
        return URL(string: "https://devapi.luckytrip.co.uk/api/2.0/test/")!
    }
    var url : URL {
        return basicURL.appendingPathComponent(self.rawValue)
    }
    
    case getAllDestinations = "destinations"//?search_type=city_or_country&search_value=d"
    
}
