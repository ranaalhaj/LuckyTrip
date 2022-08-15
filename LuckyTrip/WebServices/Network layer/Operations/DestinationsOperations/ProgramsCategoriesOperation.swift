//
//  ProgramsCategoriesOperation.swift
//  RoyaTV
//
//  Created by Ikhlas El-shair on 12/18/21.
//

import Foundation


class ProgramsCategoriesOperation: UORequestOperation<ProgramsCategories, Any>{
    
    override func start() {
        var request = URLRequest(url: API.getProgramsCategories.url)
        request.get()
        sendRequest(request)
    }
    
    override func getHttpParameters() -> [URLQueryItem] {
        return [URLQueryItem(name: "device_size", value: AppConstants.deviceSize),
                URLQueryItem(name: "device_type", value: AppConstants.deviceType)] // 2: For Mobile
    }
}
