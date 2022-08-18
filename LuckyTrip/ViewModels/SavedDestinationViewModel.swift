//
//  DestinationViewModel.swift
//  LuckyTrip
//
//  Created by Rana Alhaj on 17/08/2022.
//
import Foundation
import SwiftyJSON
import Localize_Swift


class SavedDestinationViewModel {
    weak var dataSource : GenericDataSource<[SavedDestinations]>?
    weak var delegate : DestinationsForMeViewController?
    
    init(dataSource : GenericDataSource<[SavedDestinations]>?) {
        self.dataSource = dataSource
        
    }
    
    
    func fetchData(completion: @escaping (Bool)->()) {
        CoreDataModel.shared.getSavedDestinations { result in
            guard let result = result else {
                completion(false)
                return
            }
            self.dataSource?.data.value.removeAll()
            self.dataSource?.data.value.append(result)
            completion(true)
        }
    }
    
    
    
    func deleteDest(SavedDest : SavedDestinations){
        CoreDataModel.shared.deleteSavedDest(item: SavedDest)
    }
}
