//
//  NGLocationManager.swift
//  NeighborhoodGems
//
//

import Foundation
import CoreLocation

class NGLocationManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager!

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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .denied:
                print("Setting option is denied")
            case .notDetermined:
                print("Setting option is notDetermined")
            case .authorizedWhenInUse:
                print("Setting option is authorizedWhenInUse")
                locationManager?.requestLocation()
            case .authorizedAlways:
                print("Setting option is authorizedAlways")
                locationManager?.requestLocation()
            case .restricted:
                print("Setting option is restricted")
            default:
                print("LocationManager - default case")
        }
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
