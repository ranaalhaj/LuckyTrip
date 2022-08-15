//
//  SeriesesGenresOperation.swift
//  RoyaTV
//
//  Created by Ikhlas El-shair on 12/13/21.
//

import Foundation

class SeriesesGenresOperation: UORequestOperation<SeriesGenres, String>{
    
    override func start() {
        var request = URLRequest(url: API.getSeriesCategories.url)
        request.get()
        sendRequest(request)
    }
}
