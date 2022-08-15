//
//  ProgramsToggleOperation.swift
//  RoyaTV
//
//  Created by Sobhi Imad on 05/01/2022.
//

import Foundation

class ProgramsToggleOperation:UORequestOperation<ResponseModelToggle,(String,MyListType)>{
    override func start() {
        var url:URL
        if parameters!.1 == .programs{
            url = API.programsToggle.urlWithId(parameters!.0)
        }else{
            ///episods
            url = API.episodeToggle.urlWithId(parameters!.0)
        }
        var request = URLRequest(url: url)
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
