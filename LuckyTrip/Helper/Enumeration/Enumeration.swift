//
//  Enumeration.swift


import Foundation
import UIKit
import SwiftUI

enum Result<String>{
    case success
    case failure(String)
}
enum NetworkResponse {
    case success
    case unauthrized
    case badRequest
    case outdated
    case UnprocessableEntity
    case failed
    case noData
    case unableToDecode
    case serverError


    var title:String{
        switch self {
        case .success:
            return "success"
        case .unauthrized:
            return "You need to be authenticated first".localized
        case .badRequest:
            return "Bad request"
        case  .outdated:
            return "The url you requested is outdated"
        case .UnprocessableEntity:
            return "422 Unprocessable Entity"
        case .failed:
            return "Network request failed"
        case .noData:
            return "Page not found 404"
        case .unableToDecode:
            return "We could not decode the response"
        case .serverError:
            return "internal server erorr 500"
        }
    }
}
