//
//  AddSeriesActionOperation.swift
//  RoyaTV
//
//  Created by Ikhlas El-shair on 12/15/21.
//

import Foundation

class AddSeriesActionOperation: UORequestOperation<SeriesAction, (ActionType,String)>{
    
    override func start() {
        var url: URL?
        switch parameters!.0{
        case .favorite:
            url = API.addSeriesFavorite.urlWithId(parameters!.1)
        case .notify:
            url = API.addSeriesNotify.urlWithId(parameters!.1)
        case .reminder:
            url = API.addSeriesReminder.urlWithId(parameters!.1)
        }
        var request = URLRequest(url: url!)
        request.get()
        sendRequest(request)
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
