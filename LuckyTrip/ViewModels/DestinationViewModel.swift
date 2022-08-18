//
//  DestinationViewModel.swift
//  LuckyTrip
//
//  Created by Rana Alhaj on 17/08/2022.
//
import Foundation
import SwiftyJSON
import Localize_Swift


class DestinationViewModel {
    weak var dataSource : GenericDataSource<DestinationListModel>?
    weak var delegate : DestinationsHomeViewController?
    
    init(dataSource : GenericDataSource<DestinationListModel>?) {
        self.dataSource = dataSource
        
    }
    
    
    func fetchData(searchWord: String? , searchType: String?, completion: @escaping (Bool)->()) {
        URLCache.shared.removeAllCachedResponses()
        NetworkManager.shared.provider.request(.destinationsList(search_value: searchWord ?? "" , search_type: searchType ?? SearchType.none.rawValue)) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    do {
                        print(response.data)
                        let data : DestinationListModel = try JSONDecoder().decode(DestinationListModel.self, from: response.data)
                        self.dataSource?.data.value.removeAll()
                        self.dataSource?.data.value.append(data)
                        completion(true)
                        
                    } catch {
                        print(error.localizedDescription)
                        completion(false)
                    }
                case .failure(let error):
                    print(error.errorDescription ?? "")
                    completion(false)
                    
                }
            }
        }
        
    }
}
