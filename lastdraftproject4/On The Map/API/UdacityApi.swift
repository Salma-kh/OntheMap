//
//  UdacityApi.swift
//  On The Map
//
//  Created by salma apple on 12/23/18.
//  Copyright © 2018 Salma Z. All rights reserved.
//

import UIKit

class UdacityApi: NSObject {
    
    static var uSession = URLSession.shared
    
    class func udacitynstance() -> UdacityApi {
        struct Singin {
            static var udacitynstance = UdacityApi()
        }
        return Singin.udacitynstance
    }
    //  Store variables
    static var sessionID: String? = nil
    static var accountID: String? = nil
    static var nickname : String? = nil
    static var firstName: String? = nil
    static var lastName: String? = nil
    // create session
    func postSession(_ url_path: String, username: String, password: String, completionHandlerForPOST: @escaping (_ result: [String:AnyObject]?, _ success: Bool, _ error: String?) -> Void) -> URLSessionDataTask {
        let request = NSMutableURLRequest(url: URL(string: url_path)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonDict: [String: Any] = ["udacity": ["username": username,"password": password]]
        let json = try! JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
        request.httpBody = json
        
        let task = UdacityApi.uSession.dataTask(with: request as URLRequest) { data, response, error in
            
            guard let _ = data else {
                DataHandling.fixdata.handleErrors(data, response, error as NSError?, completionHandler: completionHandlerForPOST)
                return
            }
            
            let Data = data?.subdata(in: Range(uncheckedBounds: (5, data!.count)))
            
            self.convertData(Data!, complationHandler: completionHandlerForPOST)
            
        }
        task.resume()
    
        return task
    }
    func deleteSession(deleteHandler: @escaping (_ result: [String:AnyObject]?, _ success: Bool, _ error: String?) -> Void) -> URLSessionDataTask {
        let request = NSMutableURLRequest(url: URL(string:  UdacitySruct.ApiSessionUrl)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let Cookies = HTTPCookieStorage.shared
        for cookie in Cookies.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = UdacityApi.uSession.dataTask(with: request as URLRequest) { data, response, error in
            
            guard let _ = data else {
                DataHandling.fixdata.handleErrors(data, response, error as NSError?, completionHandler: deleteHandler)
                return
            }
            DataHandling.fixdata.handleErrors(data, response, error as NSError?, completionHandler: deleteHandler)
            let Data = data?.subdata(in: Range(uncheckedBounds: (5, data!.count)))
            self.convertData(Data!, complationHandler: deleteHandler)
        }
        task.resume()
        
        return task
    }
    //  end the session when logout
    func endSession(HandlerForDeleteSession: @escaping (_ success: Bool, _ error: String?) -> Void) {
        let _ = deleteSession { (result, success, error) in
            if success {
                HandlerForDeleteSession(true, nil)
            } else {
                HandlerForDeleteSession(false, error)
            }
        }
    }
    private func convertData(_ data:Data ,complationHandler: (_ result: [String:AnyObject]?, _ success: Bool, _ error: String?) -> Void) {
        let pResult : AnyObject!
        do{
            pResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject}
        catch{complationHandler(nil,false, "Sorry there is an error parsing the JSON")
            return}
        complationHandler(pResult as? [String:AnyObject], true, nil)
        
    }
    
    
   //allow users to login
    func allowUsertologin(username: String, password: String, completionHandlerForAlogin: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        let _ = postSession( UdacitySruct.ApiSessionUrl, username: username, password: password) { (result, success, error) in
            
            guard let _ = result else {
                completionHandlerForAlogin(false, UdacitySruct.NetworkProblems)
                return
            }
            
            guard let session = result?["session"], let sessionID = session["id"] as? String, let account = result?["account"], let accountID = account["key"] as? String else {
                print("Error")
                completionHandlerForAlogin(false, UdacitySruct.IncorrectEntry)
                return
            }
            // Store the IDs
            UdacityApi.sessionID = sessionID
            UdacityApi.accountID = accountID
            
            let _ = self.getUserData(completionHandlerForUserData: { (result, success, error) in
                
//                guard let user = result?["user"] else {
//                    print("Error")
//                    return
//                }
                
                guard let firstName = result?["first_name"] as? String, let lastName = result?["last_name"] as? String else {
                    print("Error")
                    return
                }
                
                UdacityApi.firstName = firstName as String
                UdacityApi.lastName = lastName as String
            })
            
            completionHandlerForAlogin(true, nil)
        }
    }
    func getUserData(completionHandlerForUserData: @escaping (_ result: [String:AnyObject]?, _ success: Bool, _ error: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "\(UdacitySruct.ApiUserIdUrl)\(UdacityApi.accountID!)")!)
        let task = UdacityApi.uSession.dataTask(with: request as URLRequest) { data, response, error in
            
            guard let _ = data else {
                completionHandlerForUserData(nil, false, UdacitySruct.NetworkProblems)
                return
            }
            
            DataHandling.fixdata.handleErrors(data, response, error as NSError?, completionHandler: completionHandlerForUserData)
            let Data = data?.subdata(in: Range(uncheckedBounds: (5, data!.count)))
            self.convertData(Data!, complationHandler: completionHandlerForUserData)
        }
        task.resume()
    }
    
    
}
