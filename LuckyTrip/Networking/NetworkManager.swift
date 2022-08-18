//
//  NetworkManager.swift
//  LuckyTrip
//
//  Created by Rana Alhaj on 17/08/2022.
// 


import Foundation
import Moya

struct NetworkManager {
   
    static let shared =  NetworkManager()
    static let APIKey = ""
    let provider = MoyaProvider<Apis>(plugins: [NetworkLoggerPlugin()])
    
}
