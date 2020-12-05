//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by salma apple on 12/22/18.
//  Copyright © 2018 Salma alenazi. All rights reserved.
//

import UIKit
import Foundation

struct StudentInformation{
    
    static var studentLocations = [StudentInformation]()
    
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var uniqueKey: String?
    let nickname : String?
    var fullName: String? {
        return "\(String(describing: firstName))) \(String(describing: lastName)))"
    }
    
    init(dictionary: [String:AnyObject]) {
        self.firstName = dictionary["firstName"] as? String
        self.lastName = dictionary["lastName"]  as? String
        self.latitude = dictionary["latitude"]  as? Double
        self.longitude = dictionary["longitude"] as? Double
        self.mapString = dictionary["mapString"] as? String
        self.mediaURL = dictionary["mediaURL"]  as? String
        self.uniqueKey = dictionary["uniqueKey"] as? String
        self.nickname = dictionary["nickname"] as? String
    }

}


