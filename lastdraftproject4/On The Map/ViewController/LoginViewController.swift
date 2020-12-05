//
//  VLoginViewController.swift
//  OnTheMap
//
//  Created by salma apple on 12/21/18.
//  Copyright © 2018 Salma alenazi. All rights reserved.
//

import UIKit
import Foundation
class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var signUp: UIButton!
    
        override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //login method
    func Login() {
        email.text = ""
        password.text = ""
        if let mapController = storyboard?.instantiateViewController(withIdentifier: "MapAndTableVC") {
            present(mapController, animated: true, completion: nil)
        }
    }
    func displayAlert(_ error: String) {
        let alert = UIAlertController(title: "Error!", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //verify url
    func VerifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url  = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    @IBAction func signInAction(_ sender: Any) {
        self.view.endEditing(true)
        UdacityApi.udacitynstance().allowUsertologin(username: email.text!, password: password.text!) { (result, error) in
            if error != nil {
                self.displayAlert(error!)
            } else {
                DispatchQueue.main.async {
                    
                    self.Login()
                }
            }
            
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        UIApplication.shared.open(URL(string: UdacitySruct.SignUpUrl)!, options: [:], completionHandler: nil)

    }
}

