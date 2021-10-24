//
//  NetworkConstants.swift
//  MeddyTeddy_chatBot
//
//  Created by ketan jogal on 24/10/21.
//

import Foundation
import UIKit

struct NetworkOperationsKeys {
    struct Response {
        static let response = "response"
        static let error = "error"
        static let errorMessage = "error_message"
        static let errorCode = "error_code"
    }
    
    struct Notification {
        static let refreshToken = "refreshTokenNotification"
    }
    
    struct ApiCall {
        static let authorization = "Authorization"
        static let tempAuthorization = "temp-authorization-token"
        static let contentType = "Content-Type"
    }
}

typealias HTTPHeaders = [String:String]
typealias Parameters = Any
typealias handler = (_ response:Any? , _ error:Error?,_ tag:String? , _ statusCode:Int?)->Void
