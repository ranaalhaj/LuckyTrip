//
//  APIConstants.swift
//  UnitOneTemplate
//
//  Created by Ahmed Qazzaz on 6/9/20.
//  Copyright © 2020 unitone. All rights reserved.
//

import Foundation
/*This is a Tamplate class*/

// Typealias for callback functions signatures

typealias ERROR_CALLBACK_HANDLER = (_ error : NSError?)->Void
typealias SUCCESS_CALLBACK_HANDLER<T> = (_ data : T?)->Void
typealias NetworkRouterCompletion = (_ responseData: (Any)? , _ error: String?)->()
// End of typealias


//API enum used to save all your APIs
enum API : String{
    private var basicURL : URL {
        return URL(string: "http://roya22.roya.tv/api/v01/")!
    }
    private var globalURL : URL {
        return URL(string: "https://new-global.roya.tv/api/v4/")!
    }
    static var basicURL_test : URL{
        return URL(string: "")!
    }
    
    var url : URL {
        return basicURL.appendingPathComponent(self.rawValue)
    }
    var urlGlobal : URL {
        return globalURL.appendingPathComponent(self.rawValue)
    }


    func urlforUser(userType:UserTypeAPI)->URL {
        let link = userType.rawValue + self.rawValue
        return basicURL.appendingPathComponent(link)
    }
    
    func urlWithId(_ id : String) -> URL {
        let url = basicURL.appendingPathComponent(self.rawValue.replacingOccurrences(of: "{id}", with: id))
        return url
    }
    
    
    func urlWithIdPageIndex(id : String, page_index: String ) -> URL {
        let url = basicURL.appendingPathComponent(self.rawValue.replacingOccurrences(of: "{id}/{page_index}", with: (id + "/" + page_index)))
        return url
    }
    
    case talentsList = "talents-list"
    case talentDetails = "talent/{id}"
    case servicesList = "services-list"
    case interestsList = "interests-list"
    //MARK: - Auth EndPoints
    case checkPhone = "checkphone"
    case checkEmail = "checkemail"
    case updatePhone = "user/update-phone"
    case verificationEmail = "verification"
    case loginSocial =  "login/social"
    case register = "register"
    case updateUser = "user/update"
    case updateEmail = "user/update-email"
    case login = "login"
    case resendCode = "send-verification-code"
    case forgotPassword = "forget-password"
    case createfcm = "fcm/create"
    case deletefcm = "fcm/delete"
    case changePassword = "user/change-password"
    case categories = "articles/categories"
    case articlesDetails = "articles/{id}"
    case articlesTag = "articles/tag/{id}"
    case articlesCategory = "articles/category/{id}/{page_index}"
    case mainPage = "articles/main-page"
    case getStories = "stories"
    case getUserDevices = "user-devices"
    case editUserDevice = "user-devices/update"
    case addNewDevice = "user-devices/store"
    case deleteUserDevice = "user-devices/{id}"
}

enum UserTypeAPI: String{
    case sales = "sales/"
    case customer = "customer/"
}

