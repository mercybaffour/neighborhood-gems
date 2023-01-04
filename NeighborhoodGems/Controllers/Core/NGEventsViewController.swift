//
//  NGEventsViewController.swift
//  NeighborhoodGems
//
//

import UIKit

class NGEventsViewController: UIViewController {

    //MARK: Management
    //Provides data to populate our grid view
    var eventsDataSource: [NGEvent] {
        return NGDataManager.shared.eventsList
    }
    
    //To manage user's current location
    var locationService = NGLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationService.start()
        loadEvents(ll: getLatLong())
    }
    
}

extension NGEventsViewController {
    //MARK: Location Services
    //Calling service method to fetch events based on current location
    private func loadEvents(ll: String) {
        NGService.getEvents(ll: ll) { (success, list) in
            
            if success, let list = list {
                NGDataManager.shared.eventsList = list
                
                DispatchQueue.main.async {
                    print(NGDataManager.shared.eventsList)
                }
            } else {
                // show no data alert
                self.displayNoDataAlert(title: "We apologize...", message: "No events to display =(")
            }
            
        }
    }
    
    private func getLatLong() -> String {
        let latitude = locationService.locationManager.location!.coordinate.latitude
        let longitude = locationService.locationManager.location!.coordinate.longitude
        let latLong = "\(latitude),\(longitude)"
        return latLong
    }
    
    private func displayNoDataAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Okay", style: .cancel, handler: { (action) -> Void in
        })
        
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
    
}
