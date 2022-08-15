//
//  UORequestOperation.swift
//  UnitOneTemplate
//
//  Created by Ahmed Qazzaz on 6/9/20.
//  Copyright © 2020 unitone. All rights reserved.
//

import Foundation

/// Feed you request with Body parameters, headers, and GET query items
protocol UORequestOperationProtocol: NSObjectProtocol {
    func getHttpBody()->[String:Any]
    func getHttpHeader()->[String:String]
    func getHttpParameters()->[URLQueryItem]
    func httpBodyParamsOfDataType()->Data
    func cachingURL()->Bool



}

extension UORequestOperationProtocol {
    //      func getHttpBody()->[String:Any]{return[:]}
    //      func getHttpHeader()->[String:String]{return[:]}
    //      func getHttpParameters()->[URLQueryItem]{return[]}
}

///Request Operation is a special case of background operation which is responsible of URL requests
/// - Generic types
///     - T : is a generic struct type that should perform ``Codable`` protocol, and it refers to the data model that will be returen in response
///     - P : is any object or struct you can pass to the operation, you can use it to pass your body parameters in POST URL request
///
/// When subclass this class you need to define the bodyformat, the default is raw (JSON format)
class UORequestOperation<T : Codable, P> : UOOperation<T,P>, UORequestOperationProtocol{





    ///Setting body format to be JSON or Query
    ///
    ///- JSON format such as  ``{"username":"AhmedQazzaz", "password" : "123456"}``
    ///- Query format such as `` username=AhmedQazzaz&password=123456``
    ///
    /// Content
    ///- ``.raw``
    ///- ``.form``
    enum BodyFormate {
        ///Will send body as json format e.g. {"username":"AhmedQazzaz", "password" : "123456"}
        /// file_get_content("php://input")
        case raw

        ///Will send boday as query format e.g. username=AhmedQazzaz&password=123456
        /// $_POST[''] <==> filter_input(INPUT_POST, '')
        case form
    }

    var bodyFormat : BodyFormate = .raw

    init(parameters: P? = nil, bodyFormat : BodyFormate = .raw) {
        super.init(parameters: parameters)
        self.bodyFormat = bodyFormat
    }

    ///Common and unified request sending function, we can customize our request throught this function
    /// - Parameter request : is the URL request to send, should contains all request's specific headers, and parameters
    /// - Parameter parameters : the data that will be passed to the HTTPBody
    func sendRequest( _ request : URLRequest){
        //Copy structs
        var requestToSend = request
        let params = getHttpBody()
        //        let paramsdata = httpBodyParamsOfDataType()

        let paramsString = bodyFormat == .raw ? params.jsonFormattedString : params.queryFormattedString
        // common headers if exists such as "Content-Type:application/json"
        getHttpHeader().forEach { (pairs) in
            let (key, value) = pairs
            requestToSend.addValue(value, forHTTPHeaderField: key)
        }

        // Prepare URLQuery items(aka. GET parameters)
        var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)
        if getHttpParameters().count > 0{
            components?.queryItems = getHttpParameters()
        }
        requestToSend.url = components?.url
        if cachingURL(){
            if isConnectedToNetworkConstant() {
                requestToSend.cachePolicy = .reloadIgnoringLocalCacheData
            }else {
                requestToSend.cachePolicy = .returnCacheDataElseLoad
            }
        }
        print("\n body Request:\(paramsString) \n")
        print("\n body Request:\(params) \n")
        if request.httpMethod != "GET"
        {
            requestToSend.httpBody = paramsString?.data(using: .utf8) // << set POST parameters
        }
        print(" \n URLRequest:\(requestToSend.url) \n")
        URLSession.shared.dataTask(with: requestToSend) { [weak self](data, response, error) in
            guard let wself = self else {return}
            if let error = error {
                wself.raisError(message:error.localizedDescription, code: (response as? HTTPURLResponse)?.statusCode ?? -7003)
            }else{
                if let httpResponse = response as? HTTPURLResponse {
                    print("statusCode \(httpResponse.statusCode)")
                    let message: String = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                    print("message for statusCode httpResponse",message)
                    let result = wself.handleNetworkResponse(httpResponse.statusCode)
                    switch result {
                    case .success:
                        if let data = data {
                            print(" \n Response result : \(String(data: data, encoding: .utf8)) \n")
                            do{
                                let responseObject = try JSONDecoder().decode(T.self, from: data)

                                wself.requestDidFinish(withData: responseObject)
                            }catch let error{
                                print(error)
                                wself.raisError(message: error.localizedDescription, code: -7000)
                            }
                        }else{
                            wself.raisError(message: String.noResponseError, code: -7000)
                        }
                    case .failure(let message):
                        wself.raisError(message: message, code: httpResponse.statusCode)
                    }
                }
            }
        }.resume()
    }

    func uploadRequest(request : URLRequest, data: Data){

        var rr = request
        rr.allHTTPHeaderFields = getHttpHeader()
        var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)
        components?.queryItems = getHttpParameters()
        rr.url = components?.url
        print(" \n URLRequest:\(rr.url) \n")
        URLSession.shared.uploadTask(with: rr, from: data) { [weak self] (data, response, error) in
            guard let wself = self else {return}
            if let error = error {
                wself.raisError(message:error.localizedDescription, code: (response as? HTTPURLResponse)?.statusCode ?? -7003)

            }else{
                if let data = data {
                    let str = String(data: data, encoding: .utf8)
                    print(str ?? "Empty string")
                    do{
                        let responseObject = try JSONDecoder().decode(T.self, from: data)

                        wself.requestDidFinish(withData: responseObject)
                    }catch let error{
                        print(error)
                        wself.raisError(message: error.localizedDescription, code: -7000)
                    }

                }
                else
                {
                    wself.raisError(message: String.noResponseError, code: -7000)
                }
            }
        }.resume()
    }


    final public func requestDidFinish(withData data: T?){
        response = data
        didFinish(withData: data)
        isFinished = true
    }


    func didFinish(withData data: T?){
        //UnitOneSignature.print("did Finish function has no implmentation", level: .warnings)
    }

    // Shoud override this function
    override func start() {
        NSException(name: NSExceptionName(rawValue: "Method does not have code"), reason: "You are calling start function from the super class, line\(#line) - function \(#function) - file \(#file)", userInfo:nil).raise()
    }

    // No need to override this function :: it is just perfect 😎
    final func raisError(message : String, code : Int){
        error = NSError(domain: message, code: code, userInfo: nil)
        isFinished = true
    }
    func handleNetworkResponse(_ statusCode: Int) -> Result<String>{
        switch statusCode {
        case 200...299: return .success
        case 401: return .failure(NetworkResponse.unauthrized.title)
        case 404: return .failure(NetworkResponse.noData.title)
        case 422: return .failure(NetworkResponse.UnprocessableEntity.title)
        case 405...499: return .failure(NetworkResponse.failed.title)
        case 500: return .failure(NetworkResponse.serverError.title)
        default: return .failure(NetworkResponse.failed.title)
        }
    }


    func getHttpBody()->[String:Any]{return[:]}
    func getHttpHeader()->[String:String]{return[:]}
    func getHttpParameters()->[URLQueryItem]{return[]}
    func httpBodyParamsOfDataType() -> Data {return Data()}
    func cachingURL() -> Bool {return false}

}
