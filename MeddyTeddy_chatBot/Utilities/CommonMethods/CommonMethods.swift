//
//  CommonMethods.swift
//  MeddyTeddy_chatBot
//
//  Created by ketan jogal on 24/10/21.
//

import Foundation
func timeStringFromUnixTime(unixTime: Double) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = DateFormate.timeIn24WithoutSeconds.rawValue
    let date = NSDate(timeIntervalSince1970: unixTime)
    return dateFormatter.string(from: date as Date)
}
enum DateFormate:String {
    case timeIn24WithoutSeconds = "HH:mm"
}
