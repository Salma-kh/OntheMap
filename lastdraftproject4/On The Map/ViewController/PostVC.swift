//
//  PostVC.swift
//  On The Map
//
//  Created by salma apple on 12/23/18.
//  Copyright © 2018 Salma Z. All rights reserved.
//

import UIKit
import MapKit
import Foundation
class PostVC: UIViewController, UITextFieldDelegate, MKMapViewDelegate {

    //addLocationView Iboutlets
    

    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var addLocationLabel: UILabel!
    @IBOutlet weak var addLocationText: UITextField!
    @IBOutlet weak var addLocationSearchButton: UIButton!
    //MapView Iboutlets
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var mapViewButton: UIButton!
    @IBOutlet weak var mapViewPic: MKMapView!
 
    
    //addWebsiteView Iboutlets
    @IBOutlet weak var addWebsiteView: UIView!
    @IBOutlet weak var addWebsiteText: UITextField!
    @IBOutlet weak var addwebsiteLabel: UILabel!
    @IBOutlet weak var addwebsiteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        self.displayView(.view1)
    }
    enum DisplayView {
        case view1
        case Map1
        case connection
    }
    func displayView(_ viewToDisplay: DisplayView) {
        switch viewToDisplay {
        case .view1:
            locationView.isHidden = false
            mapView.isHidden = true
            addWebsiteView.isHidden = true
        case .Map1:
            locationView.isHidden = true
            mapView.isHidden = false
            addWebsiteView.isHidden = true
        case .connection:
            locationView.isHidden = true
            mapView.isHidden = true
            addWebsiteView.isHidden = false
        }
    }
    struct Locations {
        let lat: Double
        let long: Double
        let map: String
        var coordinate: CLLocationCoordinate2D {
            return CLLocationCoordinate2DMake(lat, long)
        }
    }
    var postLatitude: CLLocationDegrees? = nil
    var postLongitude: CLLocationDegrees? = nil
  
    func showActivityIndicator(_ spinner: UIActivityIndicatorView!, style: UIActivityIndicatorView.Style) {
        DispatchQueue.main.async {
            let activityIndicator = spinner
            activityIndicator?.style = style
            activityIndicator?.hidesWhenStopped = true
            activityIndicator?.isHidden = false
           activityIndicator?.startAnimating()
        }
    }
    
    func hideActivityIndicator(_ spinner: UIActivityIndicatorView!) {
        DispatchQueue.main.async {
            let activityIndicator = spinner
            activityIndicator?.isHidden = true
            activityIndicator?.stopAnimating()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func searchButtonAlert(_ error: String){
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
    func submitActionAlert(_ errorTitle: String, errorMsg: String) {
        
        let alert = UIAlertController(title: errorTitle, message: errorMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func searchButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        showActivityIndicator(self.activityIndicator, style: .gray)

        let Geocoder = CLGeocoder()
        
        guard let location = addLocationText.text else {
            self.searchButtonAlert("Please enter a location")
            return
        }
        
        Geocoder.geocodeAddressString(location) { (placemarks, error) in
            
            if error != nil {
                self.searchButtonAlert("Can't find location")
                self.hideActivityIndicator(self.activityIndicator)

            } else {
                self.displayView(.Map1)
                
                let placemark = placemarks?.first
                
                if let placemark = placemark {
                    let coordinate = placemark.location?.coordinate
                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    let region = MKCoordinateRegion(center: coordinate!, span: span)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate!
                    self.postLatitude = coordinate?.latitude
                    self.postLongitude = coordinate?.longitude
                    DispatchQueue.main.async {
                        self.mapViewPic.removeAnnotation(annotation)
                        self.mapViewPic.addAnnotation(annotation)
                        self.mapViewPic.setRegion(region, animated: true)
                    }
                    
                } else {
                    self.searchButtonAlert("No matches for that location")
                }
            }
            
            
        }

        
        
    }

    @IBAction func addPinButtonAction(_ sender: UIButton) {
        self.displayView(.connection)
////        addWebsiteView.isHidden = true
//        mapViewButton.isHidden = false
        self.hideActivityIndicator(self.activityIndicator)

    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        if addWebsiteText.text!.isEmpty {
            submitActionAlert("No Website", errorMsg: "Please add a website")
            return
        }
        ParseApi.pInstance().postAlltLocations(mapString: addLocationText.text!, mediaUrl: addWebsiteText.text!, latitude: postLatitude!, longitude: postLongitude!) { (result, success, error) in
            
            if error != nil{
                DispatchQueue.main.async {
                    self.submitActionAlert("Network issues", errorMsg: "Please check your internet connection")
                }
                return
            }
            else{
                _=result
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.hideActivityIndicator(self.activityIndicator)
            }
        }
        
    }

    
    //cancel
    
    @IBAction func Cancelview1(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)

    }
    @IBAction func Cancelview2(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)

    }
    @IBAction func Cancelview3(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)

    }
}
