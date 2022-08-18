//
//  DestinationListModel.swift
//  LuckyTrip
//
//  Created by Rana Alhaj on 17/08/2022.
//
import Foundation


import Foundation


class DestinationListModel: Codable{
    var destinations: [DestinationModel]?
 
    enum CodingKeys: String, CodingKey {
        case destinations = "destinations"
    }

    init(destinations: [DestinationModel]?) {
        self.destinations = destinations
    
    }

}


