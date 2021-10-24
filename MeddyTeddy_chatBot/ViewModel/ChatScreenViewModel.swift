//
//  ChatScreenViewModel.swift
//  MeddyTeddy_chatBot
//
//  Created by ketan jogal on 24/10/21.
//

import Foundation

class ChatScreenViewModel {
    var numberOfSection:Int {
        return 3
    }
    var messageArray:[ChatMessage] = []
    
    struct Keys {
        struct Request {
            static let apiKey = "apiKey"
            static let chatBotID = "chatBotID"
            static let externalID = "externalID"
            static let message = "message"
        }
    }
    
    func chatWithBot(chatMessage:ChatMessage, completion: @escaping(_ messages: RecievedMessageResponse?, _ error:String?) -> ()){
        let param: [String:Any] = [Keys.Request.apiKey:"6nt5d1nJHkqbkphe",
                                   Keys.Request.chatBotID:"63906",
                                   Keys.Request.externalID:"ketan jogal",
                                   Keys.Request.message:chatMessage.message]
        NetworkOperations.init(tag:ExtendedUrl.Chat.chat).data_request(urlParameter: param) {(response, error, tag, statusCode) in
            if let error = error {
                completion(nil, error.localizedDescription)
            } else {
                if let response = response as? [String:Any]{
                    do {
                        self.messageArray.append(chatMessage)
                        let decoder = JSONDecoder()
                        let json = try JSONSerialization.data(withJSONObject:response)
                        let message = try decoder.decode(RecievedMessageResponse.self, from: json)
                        self.messageArray.append(message.message)
                        completion(message, nil)
                    } catch let error {
                        completion(nil, error.localizedDescription)
                    }
                }
            }
        }
    }
}
