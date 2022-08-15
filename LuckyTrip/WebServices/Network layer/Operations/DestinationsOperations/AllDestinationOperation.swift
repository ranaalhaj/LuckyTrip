//
//  AllDestinationOperation.swift
//
//  Created by Rana Alhaj
//


import Foundation


class AllDestinationOperation: UORequestOperation<Destinations, Any>{
    
    override func start() {
        var request = URLRequest(url: API.getAllDestinations.url)
        request.get()
        sendRequest(request)
    }
    
    override func getHttpHeader() -> [String : String] {
        let header:[String:String] = ["Accept":"application/json"]
       
        return header
    }
    
    
    //https://devapi.luckytrip.co.uk/api/2.0/test/destinations?search_type=city_or_country&search_value=d
    override func getHttpParameters() -> [URLQueryItem] {
        return [URLQueryItem(name: "search_value", value: parameters! as! String),
                URLQueryItem(name: "search_type", value: "city_or_country")]
    
    }
}

