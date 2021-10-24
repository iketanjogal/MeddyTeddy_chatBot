//
//  ChatMessage.swift
//  MeddyTeddy_chatBot
//
//  Created by ketan jogal on 24/10/21.
//

import Foundation
struct ChatMessage:Codable {
    var message:String
    var chatBotName:String?
    var chatBotID:String?
    var emotion:String?
}
struct RecievedMessageResponse:Codable {
    var success:Bool
    var errorMessage: String
    var message: ChatMessage
}

//struct Message:Codable {
//    var chatBotName:String?
//    var chatBotID:String?
//    var message:String?
//    var emotion:String?
//}
