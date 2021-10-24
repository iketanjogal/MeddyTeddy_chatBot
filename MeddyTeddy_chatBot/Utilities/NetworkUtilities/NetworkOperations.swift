//
//  NetworkOperations.swift
//  MeddyTeddy_chatBot
//
//  Created by ketan jogal on 24/10/21.
//

import Foundation
import UIKit

let productionURL = "https://www.personalityforge.com"



// let sharedInstance = NetworkOperations(tag: ExtendedUrl.User.refresh)

let boundaryString = "Boundary-\(NSUUID().uuidString)"

class NetworkOperations<T:NetworkUrl>: Operation, NetworkRouter {
    
    private let refreshTokenNotificationName = Notification.Name.init(NetworkOperationsKeys.Notification.refreshToken)
    // MARK:- variable
    private var baseUrl = productionURL
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private let backgroundTaskName = "backgroundTaskNameAPI"
    
    // MARK:- init
    private var tag:T
    private var previousExtURL:T?
    private var previousBodyParamter:Parameters?
    private var previousUrlParamter:Parameters?
    private var handlers:handler?
    private var task:URLSessionDataTask?
    
    
    // MARK:- init
    init(tag:T) {
        self.tag = tag
         self.baseUrl = productionURL
    }
    
    deinit {
        print("deinit " + self.tag.extendedUrl)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK:- NetworkRouter Method
    func data_request(urlParameter:Parameters? = nil, parameter bodyParameter:Parameters? = nil, handler:@escaping handler ) {
        backgroundNotification()
        
        print("body parameters ====",bodyParameter)
        
        // used when using singleton class such as refresh token. to avoid multiple hit.
        guard task?.state != .running else {
            return
        }
        
        // check internet connection error

//        if !isInternetAvailable() {
//            handler(nil,NetworkError.networkNotAvailable,tag.extendedUrl,0)
//            return
//        }
        
        // when it is call for the first time, after refresh it will hit again
        if self.handlers == nil {
            previousExtURL = tag
            previousBodyParamter = bodyParameter
            previousUrlParamter = urlParameter
            handlers = handler
        }
        
        // to check if the value should be added in parameter or not
        
        let urlEncding = URLParameterEncoder.stringFromHttpParameters(data: urlParameter)
        var urlString =  baseUrl + tag.extendedUrl
        if let urlEncding = urlEncding {
            urlString = urlString + "?" + urlEncding
        }
    
        
        if let url:URL = URL(string:urlString) {
            print("request=====",urlString)
            
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = tag.methodType.rawString
            request.allHTTPHeaderFields = tag.getCommonHeader
            request.httpBody = getHttpData(parameter: bodyParameter)
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            registerBackgroundTask()
            task = session.dataTask(with: request as URLRequest) {
                (data, response, error) in
                self.handleResponse(data: data, response: response, error: error)
            }
            task?.resume()
            endBackgroundTask()
        } else {
            handler(nil,NetworkError.missingURL,tag.extendedUrl,0)
        }
    }
    
    func cancelTask() {
        task?.cancel()
    }

    func isRunning() -> Bool {
        switch task?.state {
        case .running?:
            return true
        default:
            return false
        }
    }
    
    // MARK:- Handling response
    
    private func handleResponse(data: Data?, response: URLResponse?, error:Error?) {
        responseManagement(data: data, response: response, error: error)

    }
    
    private func handleNetworkError(_ response: HTTPURLResponse?) -> Result{
        if let response = response {
            switch response.statusCode {
            case 200...299: return .success
            case 401...500: return .failure(NetworkError.authenticationError)
            case 501...599: return .failure(NetworkError.badRequest)
            case 600: return .failure(NetworkError.outdated)
            default: return .failure(NetworkError.failed)
            }
        }
        return .failure(NetworkError.failed)
    }
    
    private func responseManagement(data:Data?, response:URLResponse?, error:Error?) {
        let httpResponse = response as? HTTPURLResponse
        guard let data = data as Data?, let _:URLResponse = response, error == nil else {
            print("error")
            handlers?(nil,error,self.tag.extendedUrl,httpResponse?.statusCode)
            return
        }
        do {
            let parseJson = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            print("response==",parseJson)
            print("statusCode==",httpResponse?.statusCode ?? 0)
            if let json = parseJson as? [String:Any] {
                print("incoming json====", parseJson)
                if let errData = json[NetworkOperationsKeys.Response.error] as? [String:Any] {
                    if (errData[NetworkOperationsKeys.Response.errorCode] as? Int) != nil {
                        reponseType(nil,NetworkError.serverGenerated(message: errData[NetworkOperationsKeys.Response.errorMessage] as? String, code: errData[NetworkOperationsKeys.Response.errorCode] as? Int),self.tag.extendedUrl,httpResponse?.statusCode)
                    } else {
                        reponseType(nil,NetworkError.serverGenerated(message: errData[NetworkOperationsKeys.Response.errorMessage] as? String, code: errData[NetworkOperationsKeys.Response.errorCode] as? Int),self.tag.extendedUrl,httpResponse?.statusCode)
                    }
                } else {
                    reponseType(json,nil,self.tag.extendedUrl,httpResponse?.statusCode)
                }
            } else {
                reponseType(parseJson,nil,self.tag.extendedUrl,httpResponse?.statusCode)
            }
        }catch {
            _ = String(data: data, encoding: String.Encoding.utf8)
            reponseType(nil,error,self.tag.extendedUrl,httpResponse?.statusCode)
        }
    }
    
    private func reponseType(_ response:Any? , _ error:Error?,_ tag:String? , _ statusCode:Int?) {
        handlers?(response, error, tag,statusCode)
    }
    
    // MARK:- Private REQUEST Methods
    private func getHttpData(parameter:Parameters?) -> Data? {
        switch tag.apiContentType {
        case .json:
            let json = try? JSONParameterEncoder.encode(parameters: parameter)
            return json
        default:
            let json = try? JSONParameterEncoder.encode(parameters: parameter)
            return json
            
        }
    }
    
    
    // Calling again the last api after the refresh token is fetched again
    @objc private func callApiAgain() {
        if let _ = self.previousExtURL {
            self.data_request(urlParameter: previousUrlParamter, parameter: previousBodyParamter, handler: {(response, error, tag, statusCode) in
                
            })
        }
    }
    
    // MARK:- BackgroundTask
    private func backgroundNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reinstateBackgroundTask), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc private func reinstateBackgroundTask() {
        if isRunning() && (backgroundTask == UIBackgroundTaskIdentifier.invalid) {
            registerBackgroundTask()
        }
    }
    
    private func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
    
    private func registerBackgroundTask() {
        UIApplication.shared.beginBackgroundTask(withName: backgroundTaskName) { [weak self] in
            self?.endBackgroundTask()
        }
    }
}

