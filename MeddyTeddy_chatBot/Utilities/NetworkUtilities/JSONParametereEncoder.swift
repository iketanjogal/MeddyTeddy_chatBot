//
//  JSONParametereEncoder.swift
//  MeddyTeddy_chatBot
//
//  Created by ketan jogal on 24/10/21.
//

import Foundation
import AVFoundation

struct JSONParameterEncoder: ParameterEncoder {
    static func encode(parameters: Parameters?) throws -> Data? {
        do {
            if let para = parameters as? [String:Any], para.keys.count > 0 {
                let jsonAsData = try JSONSerialization.data(withJSONObject: para, options: [])
                return jsonAsData
            }
            if let parameters = parameters as? [[String:Any]] {
                let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                return jsonAsData
            }
            return nil
        }catch {
            throw NetworkError.encodingFailed
        }
    }
}
