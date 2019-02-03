//
//  MainViewController.swift
//  ZigZagExam
//
//  Created by Eliric Rivera on 03/02/2019.
//  Copyright © 2019 Eliric Rivera. All rights reserved.
//

import UIKit
import MapKit
import  CoreLocation
import PKHUD
class MainViewController: MainViewTableViewController,CLLocationManagerDelegate {

    var lastLocation: CLLocation?
    var locationManager: CLLocationManager?
    var HUD = PKHUD()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
//        getVenues(lat: 40.7484, lng: -73.9857)
        self.getLocation()
    }
    
    @IBAction func actionRefresh(_ sender: Any) {
        self.getLocation()
    }
    func getVenues(lat:Double, lng:Double) {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        VenuesAPI.instance.getVenueSearch(
            lat: lat,
            lng: lng,
            version: df.string(from: date),
            onSuccess: {
                [weak self] venue in
                self?.venues = venue.sorted(by: { $0.distance < $1.distance })
                self?.tableView.reloadData()
                self?.HUD.hide()
            },
            onError: {
                [weak self] errorMessage in
                self?.presentAlert(message: errorMessage.localizedDescription)
                self?.HUD.hide()
        })
    }

    
    func getLocation(){
        let hud = PKHUDProgressView(title: "Loading", subtitle: "Getting user locaton")
        hud.subtitleLabel.textAlignment = .center
        HUD.contentView = hud
        HUD.show()
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined
            && locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization))
            || locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)){
            
            if Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil{
                locationManager.requestAlwaysAuthorization()
            }
            else if Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil{
                locationManager.requestWhenInUseAuthorization()
            }
            else{
                print("no description provided")
            }
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 1000
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.startUpdatingLocation()
            
        }
        else{
            self.presentAlert(message: "Kindly enable location services")
        }
    }
    
}

extension MainViewController{
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        // singleton for get last location
        self.lastLocation = location
        // use for real time update location
        self.getVenues(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // do on error
        HUD.hide()
        self.presentAlert(message: error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
    }
    
}

extension UIViewController {
    
    func presentAlert(message: String, onOk: @escaping ()->Void = { }) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel) {
            _ in
            onOk()
        })
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

