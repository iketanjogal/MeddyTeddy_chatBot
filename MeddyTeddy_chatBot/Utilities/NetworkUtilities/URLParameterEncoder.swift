//
//  URLParameterEncoder.swift
//  MeddyTeddy_chatBot
//
//  Created by ketan jogal on 24/10/21.
//

import UIKit

struct URLParameterEncoder: ParameterEncoder {
    static func encode(parameters: Parameters?) throws -> Data? {
        if let string = stringFromHttpParameters(data: parameters) {
            return string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        }
        return nil
    }
}

// MARK : - StringFromHttpParamters
extension URLParameterEncoder: StringFromHttpParamters {
    static func stringFromHttpParameters(data:Parameters?) -> String? {
        if let parameters = data as? [String:Any], parameters.keys.count > 0 {
            let parametersString = convertJsonToString(data: parameters)
            return parametersString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        }
        return nil
    }
    
    private static func convertJsonToString(data:[String:Any]) -> String {
        var parametersString = ""
        for (key, value) in data {
            parametersString = parametersString + key + "=" + "\(value)" + "&"
        }
        parametersString = parametersString.substring(to: parametersString.index(before: parametersString.endIndex))
        return parametersString
    }
}
