//
//  SeriesByGenresOperation.swift
//  RoyaTV
//
//  Created by Ikhlas El-shair on 12/14/21.
//

import Foundation

class SeriesByGenresOperation: UORequestOperation<AllSeries, (String,String,RoyaCategory)>{
    
    override func start() {
        
        var url: URL?
        
        switch parameters!.2{
        case .series:
            url = API.getSeries.urlWithIdPageIndex(id: parameters!.0, page_index: parameters!.1)
        case .programs:
            url = API.getPrograms.urlWithIdPageIndex(id: parameters!.0, page_index: parameters!.1)
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
