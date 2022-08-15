//
//  ServicesOperation.swift
//  RoyaTV
//
//  Created by Ikhlas El-shair on 11/23/21.
//

import Foundation

class ServicesOperation : UORequestOperation<Services, Any>{

    override func start() {

        var request = URLRequest(url: API.servicesList.url)
        request.get()
        sendRequest(request)
    }
}

class InterestsOperation : UORequestOperation<Services, Any>{

    override func start() {

        var request = URLRequest(url: API.interestsList.url)
        request.get()
        sendRequest(request)
    }
}
