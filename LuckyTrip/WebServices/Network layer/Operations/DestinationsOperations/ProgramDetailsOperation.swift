//
//  ProgramDetailsOperation.swift
//  RoyaTV
//
//  Created by Ikhlas El-shair on 12/20/21.
//

import Foundation

class ProgramDetailsOperation: UORequestOperation<SeriesDetails, (String)>{
    
    override func start() {
        var request = URLRequest(url: API.getProgramDetails.urlWithId(parameters!))
        request.get()
        sendRequest(request)
    }
    
    override func getHttpParameters() -> [URLQueryItem] {
        return [URLQueryItem(name: "device_size", value: AppConstants.deviceSize2),
                URLQueryItem(name: "device_type", value: AppConstants.deviceType)] // 2: For Mobile
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
