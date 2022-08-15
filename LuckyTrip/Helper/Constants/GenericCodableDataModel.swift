//
//  ModelProtocol.swift
//  UnitOneTemplate
//
//  Created by Ahmed Qazzaz on 6/14/20.
//  Copyright © 2020 unitone. All rights reserved.
//

import Foundation



///Contains shared functions data models
///
///This protocol can only be used with codable strcuts
///- T : is generic type (associatedType) for codable struct that confirms ``GenericDataModel`` protocol
/// Example
///```
///strcut MyStruct : Codable,GenericDataModel {
///     typealias T = MyStruct
///   //Write your attributes here
///     }
///```
public protocol GenericCodableDataModel{
    associatedtype Model : Codable
    func saveToUserDefaults(usingKey key : String)
    static func retoreFromUserDefaults(byKey key: String)->Model?
    func didFailedToSaveModel(error : NSError)
}


public extension GenericCodableDataModel{
    
    var data : Data?{
        guard let codableSelf = self as? Model else {return nil}
        do{
            return try JSONEncoder().encode(codableSelf)
        }catch{
            self.didFailedToSaveModel(error: error as NSError)
        }
        return nil
    }
    
    static func get(fromData data: Data)->Model?{
        do{
            return try JSONDecoder().decode(Model.self, from: data)
        }catch{
            print("ParsingError::\(error)")
        }
        return nil
    }
    
    func saveToUserDefaults(usingKey key : String){
        if let data = self.data{
            UserDefaults[key] = data
            UserDefaults.standard.synchronize()
        }
    }
    
    static func retoreFromUserDefaults(byKey key: String)->Model?{
        if let data = UserDefaults[key] as? Data{
            return get(fromData: data)
        }
        return nil
    }
    
    static func getUser() -> Model? {
        return retoreFromUserDefaults(byKey: AppConstants.KeyUserObject)
    }

    
    func didFailedToSaveModel(error : NSError){
        print(error.domain)
    }
}


