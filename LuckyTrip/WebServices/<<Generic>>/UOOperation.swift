//
//  CommonOperation.swift
//  UnitOneTemplate
//
//  Created by Ahmed Qazzaz on 6/9/20.
//  Copyright © 2020 unitone. All rights reserved.
//

import Foundation

///Any background operation that might take long time to execute such as API call should be called through ``UOOperaion``,
/// - Author: Ahmed A. Qazzaz
///
///You need to subclass this class for each operation you will make
///```
///class LoginOperation<User> : UOOperation { ... }
///```
///
/// - Generic types
///     - T : is a generic struct type, it refers to the data model that will be returen in operation results
///     - P : is any object or struct you can pass to the operation, e.g. you can use it to pass your body parameters in POST URL request
class UOOperation<T, P>: Operation {
    var parameters : P?
    var response : T?
    var error : NSError?
    
    // Define the request statsu (i.e. did it finished or not yet)
    private var currentState: Bool = false
    override var isFinished: Bool {
        get {
            return currentState
        }
        set (newAnswer) {
            willChangeValue(forKey: "isFinished")
            currentState = newAnswer
            didChangeValue(forKey: "isFinished")
        }
    }
    
    init(parameters : P? = nil) {
        self.parameters = parameters
    }                
}

public struct MultipartRequestData {
    var file: Data
    var fileName : String
    var mimType: String
    var keyName: String
}

