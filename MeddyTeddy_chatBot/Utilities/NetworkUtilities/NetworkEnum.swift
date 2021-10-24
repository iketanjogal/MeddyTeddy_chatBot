//
//  NetworkEnum.swift
//  MeddyTeddy_chatBot
//
//  Created by ketan jogal on 24/10/21.
//

import Foundation
import UIKit

// MARK:- APIHttpMethod
enum APIHttpMethod {
    
    case get
    case delete
    case post
    case put
    case patch//(body: Data)
    
    var rawString: String {
        switch self {
        case .get:
            return "GET"
        case .delete:
            return "DELETE"
        case .post:
            return "POST"
        case .put://(_):
            return "PUT"
        case .patch://(_):
            return "PATCH"
        }
    }
}

// MARK:- APIContentType
enum APIContentType: String {
    case json = "application/json"
    case x_www_form_urlencoded = "application/x-www-form-urlencoded"
    case formData = "multipart/form-data"
    case none = ""
}
// MARK:- ServerType
enum ServerType {
    case nodejs
    case java
    case javaProduction
}
enum NetworkError : Error , NetworkErrorProtocol {
    typealias RawValue = String
    
    case serverGenerated(message:String?,code:Int?)
    case parametersNil
    case encodingFailed
    case missingURL
    case networkNotAvailable
    case sessionExpired
    case userCancelled
    case somthingWentWrong
    
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
    
    
    func errorMessage() -> RawValue? {
        switch self {
        case .serverGenerated(message:let message, code:_):
            return message
        case .parametersNil:
            return "Parameters were nil."
        case .encodingFailed:
            return "Parameter encoding failed."
        case .missingURL:
            return "URL is nil."
        case .networkNotAvailable:
            return "Please check your internet connection"
        case .sessionExpired:
            return "Session Expired"
        case .userCancelled:
            return ""
        case .somthingWentWrong:
            return "Something went wrong"
        case .authenticationError:
            return "You need to be authenticated first."
        case .badRequest:
            return "Bad request"
        case .outdated:
            return "The url you requested is outdated."
        case .failed:
            return "Network request failed."
        case .noData:
            return "Response returned with no data to decode."
        case .unableToDecode:
            return "We could not decode the response."
        }
    }
}

enum Result{
    case success
    case failure(Error)
}
