//
//  ExtendedUrl.swift
//  MeddyTeddy_chatBot
//
//  Created by ketan jogal on 24/10/21.
//

import Foundation
import UIKit

struct ExtendedUrl {
    
    // MARK:- Call
    enum Chat: NetworkUrl {
        
        case chat
        
        // MARK: - NetworkUrl
        var methodType: APIHttpMethod {
            get {
                switch self {
                case .chat:
                    return .get
                }
            }
        }
        var extendedUrl: String {
            get {
                switch self {
                case .chat:
                    return "/api/chat"
                }
            }
        }
        var apiContentType: APIContentType {
            get {
                return .json
            }
        }
        // MARK:- Methods For form data
    }
}
