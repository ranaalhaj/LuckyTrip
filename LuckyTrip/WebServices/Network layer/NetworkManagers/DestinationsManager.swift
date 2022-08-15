//
//  DestinationsManager.swift
//
//  Created by Rana Alhaj
//


import Foundation

class DestinationsManager: NetworkOperationsManager {
    func getDestinations(keyword: String, success : @escaping SUCCESS_CALLBACK_HANDLER<Destinations>,
                   failed : @escaping ERROR_CALLBACK_HANDLER){
        
        let operation = AllDestinationOperation(parameters: keyword, bodyFormat: .form)
        executeFunction(operation: operation, success: success, failed: failed)
    }
    
}


