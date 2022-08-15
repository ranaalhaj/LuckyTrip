//
//  SeriesByTagOperation.swift
//  RoyaTV
//
//  Created by Ikhlas El-shair on 12/15/21.
//

import Foundation

//class SeriesByTagOperation: UORequestOperation<AllSeries, (String,String,RoyaCategory)>{
//
//    override func start() {
//        var url: URL?
//
//        switch parameters!.2{
//        case .series:
//            url = API.getSeriesByTag.urlWithIdPageIndex(id: parameters!.0, page_index: parameters!.1)
//        case .programs:
//            url = API.getProgramsByTag.urlWithIdPageIndex(id: parameters!.0, page_index: parameters!.1)
//        }
//
//        var request = URLRequest(url: url!)
//        request.get()
//        sendRequest(request)
//    }
//
//    override func getHttpParameters() -> [URLQueryItem] {
//        return [URLQueryItem(name: "device_size", value: "Size608Q70"),
//                URLQueryItem(name: "device_type", value: AppConstants.deviceType)] // 2: For Mobile
//    }
//}

class SeriesByTagOperation: UORequestOperation<AllSeries, (String,String,RoyaCategory)>{
    
    override func start() {
        var request = URLRequest(url: API.getDataByTag.urlWithIdPageIndex(id: parameters!.0, page_index: parameters!.1))
        request.get()
        sendRequest(request)
    }
    
    override func getHttpParameters() -> [URLQueryItem] {
        return [URLQueryItem(name: "series", value: "true"),
                URLQueryItem(name: "programs", value: "true"),
                URLQueryItem(name: "articles", value: "true"),
                URLQueryItem(name: "device_size", value: AppConstants.deviceSize)]
    }
}

class SeriesByTagOperation2: UORequestOperation<AllSeries, (String,String,RoyaCategory)>{
    
    override func start() {
        var request = URLRequest(url: API.getDataByTag2.urlWithIdPageIndex2(id: parameters!.0))
        request.get()
        sendRequest(request)
    }
    
    override func getHttpParameters() -> [URLQueryItem] {
      let mm =  parameters!.0
        
        return [
            URLQueryItem(name: "episode_tag", value: mm),
            URLQueryItem(name: "device_size", value: AppConstants.deviceSize),
               ]
        
    }
}

