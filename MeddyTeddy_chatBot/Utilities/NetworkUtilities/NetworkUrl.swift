//
//  NetworkUrl.swift
//  MeddyTeddy_chatBot
//
//  Created by ketan jogal on 24/10/21.
//

import Foundation
import UIKit
// MARK:- ParameterEncoder
protocol ParameterEncoder {
    static func encode(parameters: Parameters?) throws -> Data?
}

// MARK:- URL String From Paramters
protocol StringFromHttpParamters {
    static func stringFromHttpParameters(data:Parameters?) -> String?
}

// MARK:- NetworkRouter
protocol NetworkRouter: class {
    func data_request(urlParameter:Parameters?, parameter bodyParameter:Parameters?, handler:@escaping handler )
    func cancelTask()
}

// MARK:- NetworkErrorProtocol
protocol NetworkErrorProtocol {
    func errorMessage() -> String?
}

// MARK:- NetworkUrl
protocol NetworkUrl {
    var methodType:APIHttpMethod {get}
    var extendedUrl:String {get}
    var apiContentType: APIContentType {get}
}

extension NetworkUrl {
    var getCommonHeader:[String:String] {
        get {
            var header:[String:String] = [:]
            switch apiContentType {
            case .formData:
                header[NetworkOperationsKeys.ApiCall.contentType] = apiContentType.rawValue + "; boundary=\(boundaryString)"
            default:
                header[NetworkOperationsKeys.ApiCall.contentType] = apiContentType.rawValue
            }
            return header
        }
    }
}


