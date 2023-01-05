//
//  NGLocationManager.swift
//  NeighborhoodGems
//
//

import Foundation
import CoreLocation

class NGLocationManager: NSObject, CLLocationManagerDelegate {
    
    let locationManager : CLLocationManager

    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        super.init()
        locationManager.delegate = self
    }

    func start() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {return}
        print(currentLocation)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        locationManager.stopUpdatingLocation()
    }
    
}
