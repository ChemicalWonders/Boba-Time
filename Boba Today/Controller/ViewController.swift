//
//  ViewController.swift
//  Boba Today
//
//  Created by Kevin Chan on 6/13/19.
//  Copyright © 2019 Kevin Chan. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // Constants
    let YELP_URL = "https://api.yelp.com/v3/businesses/search"
    
    let locationManager = CLLocationManager()
    let bobaStoreDataModel = BobaStore()
    
    
    @IBOutlet weak var response: UILabel!
    @IBOutlet weak var responseImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
    }


    @IBAction func button(_ sender: Any) {
        let bobaAnswer = Bool.random();
        
        if(bobaAnswer && bobaStoreDataModel.didUpdate){
            response.numberOfLines = 2;
            response.text = "Go for it! Maybe try \(bobaStoreDataModel.storeName) on \(bobaStoreDataModel.location). They have a rating of \(bobaStoreDataModel.rating) stars on Yelp!";
            responseImg.image = UIImage();
        } else if (bobaAnswer && !bobaStoreDataModel.didUpdate){
            response.numberOfLines = 5;
            response.text = "You should go for it! But since I wasn't able to find your location, I can't give you a recommendation. Try turning on Location Services, or moving to a place with a better GPS signal!"
            responseImg.image = UIImage(named: "bobae");
        }
        else {
            response.text = "Maybe not today. Try again tomorrow?";
            responseImg.image = UIImage(named: "shockedpikachu");
        }
        
        // Make label size fit new text.
        response.textAlignment = .center;
    }
    
    func getNearestBobaLocation(url: String, authorization: String, parameters: [String: Any]) {
        
        let headers: HTTPHeaders = [
            "Authorization": authorization,
            "Accept": "application/json"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the Boba Store Data");
                let yelpJSON: JSON = JSON(response.result.value!);
                self.updateBobaStoreData(json: yelpJSON);
            } else {
                print("Error \(response.result.error!)");
            }
        }
    }
    
    func updateBobaStoreData (json: JSON) {
        let bobaRNG = Int.random(in: 0 ... 19);
        let bobaStoreResult = json["businesses"][bobaRNG]["name"].stringValue;
        bobaStoreDataModel.storeName = bobaStoreResult;
        bobaStoreDataModel.imageURL = json["businesses"][bobaRNG]["image_url"].stringValue;
        bobaStoreDataModel.phone = json["businesses"][bobaRNG]["phone"].stringValue;
        bobaStoreDataModel.rating = json["businesses"][bobaRNG]["rating"].intValue;
        bobaStoreDataModel.location = json["businesses"][bobaRNG]["location"]["address1"].stringValue;
        bobaStoreDataModel.didUpdate = true;
        bobaStoreDataModel.printStoreInfo();
        
    }
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
        }
        print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
        let latitude = Float(location.coordinate.latitude);
        let longitude = Float(location.coordinate.longitude);
        
        let params: [String : Any] = ["latitude": latitude, "longitude": longitude, "term": "boba"]
        getNearestBobaLocation(url: YELP_URL, authorization: YELP_KEY, parameters: params);
    }
    
    func updateUIWithBobaStoreData() {
        
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error);
//        cityLabel.text = "Location Unavailable"
    }
}

