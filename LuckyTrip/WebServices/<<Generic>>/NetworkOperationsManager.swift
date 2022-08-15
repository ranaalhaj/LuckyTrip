//
//  NetworkOperationsManager.swift
//  UnitOneTemplate
//
//  Created by Ahmed Qazzaz on 6/9/20.
//  Copyright © 2020 unitone. All rights reserved.
//


import Foundation

/*
-----------------
Manaual
-----------------
Subclass this class to create Network Managers
- Network managers are used to hold functions of network operations such as login, signup, register, ... etc.
- Network manager also handles the response in both error and success cases
-----------------------------------------
implmentation structure of subclass
-----------------------------------------
   1. function header will take all the data that you need to pass with the request, and the handler functions references for error and success cases
   2. initiate the operation object and set its parameters
   3. define the response operation
   4. call the exeucteQueue function passing your operation as leading operation, and the response handler operation as dependend operation
*/


///Background operation queue, this calss will hold all the operatoin/requests, and will execute them in order,
///you need to subclass this class for each requests group (i.e. UserNetwrokOperation)
/// - Author: Ahmed A. Qazzaz
class NetworkOperationsManager {
    
    private let queue: OperationQueue = {
              var queue = OperationQueue()
              queue.maxConcurrentOperationCount = 2 // reduces the load
              queue.isSuspended = false // ensure the queue is active
              return queue
          }()
       

       /// Execute queues function
       /// - Parameter leadingOperation: The first operation to be executed
       /// - Parameter dependentOperation: is a list (multi paramters) of the type operation, to be executed in sequance ordere after the first operation finished.
       final internal func executeQueue(leadingOperation : Operation, dependentOperations : Operation...){
           let firstDepentedQueue = dependentOperations.first!
               // Setting the first dependent opetaion to make
               //it depented on the leading operation
           firstDepentedQueue.addDependency(leadingOperation)
               
               // Make each depentend operation to be depented on the previou operation in the operations list
               // [0] => depented on leadinOperation
               // [1] => depented on operaion[0]
               // [2] => depented on operaion[1]
               // [3] => depented on operaion[2]
               // ... and so on
           
           for i in 1..<dependentOperations.count {
                   dependentOperations[i].addDependency(dependentOperations[i-1])
           }
           
           var operations = [leadingOperation]
           operations.append(contentsOf: dependentOperations)
           queue.addOperations(operations, waitUntilFinished: false)
       }
    
    ///Generic operation exection function 
    func executeFunction<T,P:Codable, O>(operation : T,
                                         success : @escaping (_ data : P?)->Void,
                                         failed : @escaping ERROR_CALLBACK_HANDLER) where T : UORequestOperation<P,O>{
               let responseOperation = BlockOperation { [weak operation] in
                   if let error = operation?.error {
                       failed(error)
                   }
                   else{
                       success(operation?.response)
                   }
               }
               executeQueue(leadingOperation: operation, dependentOperations: responseOperation)
    }    
}
