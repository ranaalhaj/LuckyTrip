//
//  TalentsListOperation.swift
//  RoyaTV
//
//  Created by Ikhlas El-shair on 11/22/21.
//

import Foundation

class TalentsListOperation : UORequestOperation<Talents, (Int,Int)>{

    override func start() {

        var request = URLRequest(url: API.talentsList.url)
        request.get()
        sendRequest(request)
    }
    
    override func getHttpParameters() -> [URLQueryItem] {
        var items:[URLQueryItem] = []
        
        if let service_id = parameters?.0, service_id != 0{
            items.append(URLQueryItem(name: "service_id", value: "\(service_id)"))
        }
        
        if let interest_id = parameters?.1, interest_id != 0{
            items.append(URLQueryItem(name: "interest_id", value: "\(interest_id)"))
        }
        return items
    }
}
