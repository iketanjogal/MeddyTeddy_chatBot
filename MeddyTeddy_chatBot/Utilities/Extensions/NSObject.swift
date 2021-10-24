//
//  NSObject.swift
//  MeddyTeddy_chatBot
//
//  Created by ketan jogal on 24/10/21.
//

import Foundation
extension NSObject {
    static var reusableIdentifier: String {
        get {
            return "\(self)"
        }
    }
}
