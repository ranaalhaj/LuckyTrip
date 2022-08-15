//
//  GeneralNetworking.swift
//  
//
//  Created by Rana Alhaj on 14/8/22.
//

import Foundation

class GeneralNetwork{
    private init() {}
    static let shared:GeneralNetwork = GeneralNetwork()
  /*  func updateDeviceToken(complation:((Bool)->Void)? = nil){
        AuthenticationManager().updateDeviceToken { data in
            print("success update device token",data)
            if complation != nil{
                complation!(true)
                
            }
        } failed: { error in
            print("error logout")
        }
    }*/
}
