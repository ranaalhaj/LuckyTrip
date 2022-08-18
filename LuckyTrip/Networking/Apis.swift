//
//  Apis.swift
//  LuckyTrip
//
//  Created by Rana Alhaj on 17/08/2022.
//  This Class includes everything related to the apis and params

import Foundation
import Moya
import Localize_Swift

enum Apis {
    case destinationsList( search_value : String , search_type: String )
    
}

extension Apis: TargetType {
    var sampleData: Data {
        return stubbedResponse("LuckyTrip")
    }
    
    
    var baseURL: URL {
        
        switch self {
        case .destinationsList:
            guard let url = URL(string: Constants.Links.DESTINATIONS_API) else { fatalError("baseURL could not be configured.")}
            return url
            /*  default:
             guard let url = URL(string: "") else { fatalError("baseURL could not be configured.")}
             return url
             */
        }
        
    }
    
    var path: String {
        switch self {
        case .destinationsList:
            return ""
            
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .destinationsList:
            return .get
       /* default: //Default will never be arrived but this to prepare for a big application with multi apis
            return .get*/
        }
    }
    
    var task: Task {
        switch self {
        case .destinationsList(let search_value,let search_type):
            return .requestParameters(parameters: ["search_value" :search_value,"search_type": search_type], encoding: URLEncoding.default)
            
       /* default:
            return .requestPlain*/
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var headers: [String : String]? {
        switch self {
        case .destinationsList:
            return ["Accept": "application/json"]
        /*default:
            return ["Accept": "application/json"]*/
        }
        
    }
    
    
    func stubbedResponse(_ filename:String) -> Data! {
        @objc class TestClass : NSObject {}
        let bundel = Bundle(for: TestClass.self)
        let path = bundel.path(forResource: filename, ofType: "json")
        return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
    }
    
    
    
    func getDomainURL() -> String{
        return Constants.Links.MAIN_DOMAIN
    }
    
    
}
