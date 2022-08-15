//
//  TalentDetailsOperation.swift
//  RoyaTV
//
//  Created by Ikhlas El-shair on 11/22/21.
//

import Foundation

class TalentDetailsOperation : UORequestOperation<TalentDetails, String>{

    override func start() {

        var request = URLRequest(url: API.talentDetails.urlWithId(parameters ?? ""))
        request.get()
        sendRequest(request)
    }
}
