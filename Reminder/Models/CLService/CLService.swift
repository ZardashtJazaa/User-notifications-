//
//  CLService.swift
//  Reminder
//
//  Created by Zardasht  on 09/07/2022.
//

import Foundation
import CoreLocation

class CLService: NSObject {
    
    private override init() {}
    static let shared = CLService()
    
    var shouldSetRegion = true
    
    let locationManager = CLLocationManager()
    
    func authorize() {
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func updateLocations() {
        print("Update Locations!")
        shouldSetRegion = true // from here we just once set our Region State
        locationManager.startUpdatingLocation()
    }
    
}


extension CLService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Got Locations")
        
        guard let currentLocation  = locations.first , shouldSetRegion else {return}
        shouldSetRegion = false
        let region = CLCircularRegion(center: currentLocation.coordinate, radius: 20, identifier: "startPositions")
        manager.startMonitoring(for: region)
        		
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Did Enter Region Via Cl")
        NotificationCenter.default.post(name: NSNotification.Name("InternalNotifications.enteredRegion"), object: nil) // An internal Notifications for handling leaveing region ,  we can use userNotifications but that not work perfectly...
    }
    
}
