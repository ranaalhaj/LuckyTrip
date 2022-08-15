//
//  SeriesSeasonsOperation.swift
//  RoyaTV
//
//  Created by Ikhlas El-shair on 12/14/21.
//

import Foundation

class SeriesSeasonsOperation: UORequestOperation<SeriesDetails, (String,RoyaCategory)>{
    
    override func start() {
        var url: URL?
        switch parameters!.1{
        case .series:
            url = API.getSeriesSeasons.urlWithId(parameters!.0)
        case .programs:
            url = API.getProgramSegments.urlWithId(parameters!.0)
        }
        var request = URLRequest(url: url!)
        request.get()
        sendRequest(request)
    }
    
    override func getHttpParameters() -> [URLQueryItem] {
        return [URLQueryItem(name: "device_size", value: AppConstants.deviceSize),
                URLQueryItem(name: "device_type", value: AppConstants.deviceType)] // 2: For Mobile
    }
}
