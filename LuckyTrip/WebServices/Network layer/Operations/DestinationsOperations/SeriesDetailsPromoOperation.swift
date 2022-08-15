//
//  SeriesDetailsPromoOperation.swift
//  RoyaTV
//
//  Created by Tareq Mohammad on 3/13/22.
//
// Edited By Tariq Mohammad 13-March

import Foundation

class SeriesDetailsPromoOperation: UORequestOperation<EpisodeTicketGenerationModel, (String)>{

    override func start() {
        var request = URLRequest(url: API.mainPage.PromoTicketGenerationUrl(id: parameters!))
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
