//
//  UdacitySruct.swift
//  On The Map
//
//  Created by salma apple on 12/23/18.
//  Copyright © 2018 Salma Z. All rights reserved.
//

import UIKit
import Foundation
struct  UdacitySruct{
    
    static let ApiSessionUrl = "https://onthemap-api.udacity.com/v1/session"
    static let ApiUserIdUrl = "https://onthemap-api.udacity.com/v1/users/"
    static let SignUpUrl = "https://www.udacity.com/account/auth#!/signup"
    static let NetworkProblems = "Not connected to a internet. Check your internet settings."
    static let IncorrectEntry = "Incorrect details. please Enter correct details."
    static let NoData = "No data was found!"
    
}
// handel incorrect data
class DataHandling {
    static let fixdata = DataHandling()
    
    func handleErrors(_ data: Data?, _ response: URLResponse?, _ error: NSError?, completionHandler: @escaping (_ result: [String:AnyObject]?, _ success: Bool, _ error: String?) -> Void) {
        
        guard (error == nil) else {
            completionHandler(nil, false, UdacitySruct.NetworkProblems)
            return
        }

        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            completionHandler(nil, false, UdacitySruct.IncorrectEntry)
            return
        }
        guard let _ = data else {
            completionHandler(nil, false, UdacitySruct.NoData)
            return
        }
    }
    
}
