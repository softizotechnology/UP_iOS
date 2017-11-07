//
//  LocationManager.swift
//  Unity Peace
//
//  Created by bsingh9 on 06/11/17.
//  Copyright © 2017 com. All rights reserved.
//

import CoreLocation
import UIKit

class LocationManager : NSObject,CLLocationManagerDelegate {

    var isWorking = false
    var locationStatus : NSString = "Not Started"
    var manager : CLLocationManager?
    var isUpdateInProgress = false
    
    static let LocationDidUpdateNotification = Notification.Name("LocationDidUpdateNotification")
    
    func startLocationUpdate () {
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        if  CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            manager?.startUpdatingLocation()
        } else {
            manager?.requestWhenInUseAuthorization()
        }
    }
    
    func stopLocationUpdate () {
        if isWorking {
            isWorking = !isWorking
            manager?.stopUpdatingLocation()
        }
    }
    
    //MARK: CLLocationManagerDelegate
    @objc func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Error while updating the location, \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last
        print("Did update new location, \(String(describing: newLocation))")
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.location = newLocation
        self.stopLocationUpdate()
        if let _ = newLocation {
            NotificationCenter.default.post(name: LocationManager.LocationDidUpdateNotification, object:newLocation)
        }
        
    }
    
    // authorization status
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
        case CLAuthorizationStatus.restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.notDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            manager.startUpdatingLocation()
            self.isWorking = true
        } else {
            NSLog("Denied access: \(locationStatus)")
        }
    }
}
