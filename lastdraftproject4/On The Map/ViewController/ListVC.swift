//
//  ListVC.swift
//  On The Map
//
//  Created by salma apple on 12/23/18.
//  Copyright © 2018 Salma Z. All rights reserved.
//

import UIKit

class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableList.delegate = self
        tableList.dataSource = self
    }
    func getLocations() {
        ParseApi.pInstance().displayAllLocations { (locations, success, error) in
            if success {
                
                DispatchQueue.main.async {
                    self.tableList.reloadData()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = StudentInformation.studentLocations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersCells")!
        let letters = NSCharacterSet.letters
        let fullName = "\(String(describing: student.firstName)) \(String(describing: student.lastName))"
        let range = fullName.rangeOfCharacter(from: letters)
        
        if (range != nil) {
            if (student.firstName != nil && student.lastName != nil) {
                cell.textLabel?.text = "\(student.firstName!) \(student.lastName!)"}
            else{
                cell.textLabel?.text = ParseStruct.NoName
            }
        }
            
        else {
            cell.textLabel?.text = ParseStruct.NoName
        }
        
        if let mediaUrl = student.mediaURL {
            cell.detailTextLabel?.text = mediaUrl
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformation.studentLocations.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let app = UIApplication.shared
        let mediaUrl = StudentInformation.studentLocations[indexPath.row].mediaURL
        if let toOpen = mediaUrl {
            if VerifyUrl(urlString: toOpen) {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            } else {
                displayAlert("The URL is not valid")
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.getLocations()
        }
    }
    func displayAlert(_ error: String) {
        let alert = UIAlertController(title: "Error!", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func VerifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url  = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    
    @IBAction func logoutlvc(_ sender: UIBarButtonItem) {
        UdacityApi.udacitynstance().endSession { (success, error) in
            if success {
                self.tabBarController?.dismiss(animated: true, completion: nil)
            } else {
                self.displayAlert(error!)
            }
            
            
        }
    }
}
