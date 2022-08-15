//
//  Extensions.swift
//
//  Created by Rana Alhaj on 14/8/22.
//  Copyright © 2022 ranaalhaj. All rights reserved.
//


import Foundation

extension String {
    // Locale is the most important extension variable we need in all apps
    var localized : String {
        return NSLocalizedString(self, comment: "")
    }
    
    func formatted(_ value: CVarArg...) -> String {
        return String.init(format: self, value)
    }
    
    //Other extensions to string can be added here (e.g. md5, or validations ...)
}

extension Int {
    var toString: String {
        return "\(self)"
    }
}

// This extension used to convert [String:Any] type to JSON string or Data
extension Dictionary where Key == String{
    
    /// Returns Binary (``Data``) of Dictionary object
    var jsonData : Data? {
        do{
            return try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        }catch{
            print("error : \(error)")
        }
        return nil
    }
    
    /// Returns ``String`` based on JSON formate of Dictionary
    var jsonFormattedString:String {
        do {
            let stringData = try JSONSerialization.data(withJSONObject: self as NSDictionary, options: JSONSerialization.WritingOptions.fragmentsAllowed)
            if let string = String(data: stringData, encoding: .utf8){
                return string
            }
        }catch  {
            print("error : \(error)")
            
        }
        return ""
    }
    
    var queryFormattedString:String?{
        var queries : [URLQueryItem] = []
        for (key, value) in self {
            //            if(value is [Any]){
            //                let arr  = value as! [Any]
            //                for (i, v) in arr.enumerated() {
            //                    queries.append(URLQueryItem(name: "\(key)[\(i)][]", value: "\(value)"))
            //                }
            //            }else{
            queries.append(URLQueryItem(name: key, value: "\(value)"))
            //            }
        }
        var comp = URLComponents()
        comp.queryItems = queries
        
        return comp.percentEncodedQuery
    }
    
    //Other extensions to [String:Any] can be added here
}

extension Array where Element : Comparable {
    //Other extensions to [<#AnyType#>] can be added here
}


extension UserDefaults {
    /// This subscription used to load and save data to standard user defaults
    static subscript(_ key : String)->Any? {
        set{UserDefaults.standard.set(newValue, forKey: key)}
        get{return UserDefaults.standard.object(forKey: key)}
    }
}

extension Data {
    /// Creating binary for type (String, Int, ... etc)
    init<T>(value: T) {
        self = withUnsafePointer(to: value) { (ptr: UnsafePointer<T>) -> Data in
            return Data(buffer: UnsafeBufferPointer(start: ptr, count: 1))
        }
    }
    
    
    
    
    /// Creating value from binary
    //    func to<T>(type: T.Type) -> T {
    //        return self.withUnsafeBytes { $0.load(as: T.self) }
    //    }
}
public extension URLRequest {
    mutating func post(){
        self.httpMethod = "POST"
    }
    mutating func get(){
        self.httpMethod = "GET"
    }
    mutating func delete(){
        self.httpMethod = "DELETE"
    }
    mutating func put(){
        self.httpMethod = "PUT"
    }
    mutating func patch(){
        self.httpMethod = "PATCH"
    }
}

