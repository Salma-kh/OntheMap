//
//  ParseApi.swift
//  On The Map
//
//  Created by salma apple on 12/23/18.
//  Copyright © 2018 Salma Z. All rights reserved.
//

import UIKit
import Foundation
class ParseApi: NSObject {
    class func pInstance() -> ParseApi {
        struct login {
            static var pInstance = ParseApi()
        }
        return login.pInstance
    }
    //get location
    func getAllLocations(completionHandlerForGetLocations: @escaping (_ result: [String:AnyObject]?, _ success: Bool, _ error: String?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "\(ParseStruct.ApiUrl)/\(ParseStruct.StudentLocation)\(ParseStruct.LimitAndOrder)")!)
        request.addValue(ParseStruct.AppId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseStruct.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = UdacityApi.uSession
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard let _ = data else {
                completionHandlerForGetLocations(nil, false, UdacitySruct.NetworkProblems)
                return
            }
            
            DataHandling.fixdata.handleErrors(data, response, error as NSError?, completionHandler: completionHandlerForGetLocations)
            
            self.parseData(data!, completionHandlerForConvertedData: completionHandlerForGetLocations)
        }
        
        task.resume()
    }
    // parse row json
    private func parseData(_ data: Data, completionHandlerForConvertedData: (_ result: [String:AnyObject]?, _ success: Bool, _ error: String?) -> Void) {
        
        let Result: AnyObject!
        
        do {
           Result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            completionHandlerForConvertedData(nil, false, "There was an error parsing the JSON")
            return
        }
        completionHandlerForConvertedData(Result as? [String:AnyObject], true, nil)
    }
    func postAlltLocations(mapString: String, mediaUrl: String, latitude: Double, longitude: Double, completionHandlerForPostLocation: @escaping (_ result: [String:AnyObject]?, _ success: Bool,  _ error: String?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "\(ParseStruct.ApiUrl)/\(ParseStruct.StudentLocation)")!)
        request.httpMethod = "POST"
        request.addValue(ParseStruct.AppId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseStruct.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonDictionary: [String:Any] = [
            "uniqueKey": UdacityApi.accountID!,
            "firstName": UdacityApi.firstName!,
//            "firstName": UdacityApi.firstName ?? "Salma",
            "lastName": UdacityApi.lastName!,
//            "lastName": UdacityApi.lastName ?? "Last name",
            "mapString": mapString,
            "mediaURL": mediaUrl,
            "latitude": latitude,
            "longitude": longitude
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
        request.httpBody = jsonData
        let session = UdacityApi.uSession
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard let _ = data else {
                completionHandlerForPostLocation(nil, false, UdacitySruct.NetworkProblems)
                return
            }
            DataHandling.fixdata.handleErrors(data, response, error as NSError?, completionHandler: completionHandlerForPostLocation)
            self.parseData(data!, completionHandlerForConvertedData: completionHandlerForPostLocation)
        }
        task.resume()
    }
    //display all location
    func displayAllLocations(_ completionHandlerForAnnotations: @escaping (_ result: [StudentInformation]?, _ success: Bool, _ error: String?) -> Void) {
        
        ParseApi.pInstance().getAllLocations { (results, success, error) in
            if success {
                if let data = results!["results"] as AnyObject? {
                    StudentInformation.studentLocations.removeAll()
                    for result in data as! [AnyObject] {
                        let student = StudentInformation(dictionary: result as! [String : AnyObject])
                        StudentInformation.studentLocations.append(student)
                    }
                    completionHandlerForAnnotations(StudentInformation.studentLocations, true, nil)
                }
            } else {
                completionHandlerForAnnotations(nil, false, error)
            }
        }
    }
    
}
