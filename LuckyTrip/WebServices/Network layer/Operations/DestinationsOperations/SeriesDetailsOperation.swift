//
//  SeriesDetailsOperation.swift
//  RoyaTV
//
//  Created by Ikhlas El-shair on 12/14/21.
//

import Foundation

class SeriesDetailsOperation: UORequestOperation<SeriesDetails, (String)>{

    override func start() {
        var request = URLRequest(url: API.getSeriesDetails.urlWithId(parameters!))
        request.get()
        sendRequest(request)
    }

    override func getHttpParameters() -> [URLQueryItem] {
        //Rana On 5Feb2022
        /*return [URLQueryItem(name: "device_size", value: "Size02Q100"),
                URLQueryItem(name: "device_type", value: "2")]*/
    
        return [URLQueryItem(name: "device_size", value: "Size03Q40"),
                URLQueryItem(name: "device_type", value: "2")]
    }

    override func getHttpHeader() -> [String : String] {
        if let accesstoken = _userDefaults.value(forKey: AppConstants.tokenAuth) as? String{
            var header:[String:String] = ["Accept":"application/json"]
            header["Authorization"] = "Bearer \(accesstoken)"
            return header
        }
        return [:]
    }
}
