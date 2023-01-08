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
        return NGDataHelper.shared.eventsList
    }
    
    //To manage user's current location
    var locationService = NGLocationHelper()
    
    //MARK: UI
    private lazy var eventsNearbyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 24.0)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private lazy var eventSourceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 16.0)
        label.textAlignment = .center
        label.textColor = .orange
        label.text = "brought to you by Ticketmaster"
        return label
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(NGEventListCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return cv
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationService.start()
        setupViews()
        loadEvents(ll: getLatLong())
    }
    
}

extension NGEventsViewController {
     private func setupViews() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.view.addSubview(eventsNearbyLabel)
        self.view.addSubview(eventSourceLabel)
        self.view.addSubview(collectionView)
         
        eventsNearbyLabel.translatesAutoresizingMaskIntoConstraints = false
        eventSourceLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = view.layoutMarginsGuide
        
        //Layout Constraints for eventsNearbyLabel
        NSLayoutConstraint.activate([
            eventsNearbyLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            eventsNearbyLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            eventsNearbyLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
        ])
         
        NSLayoutConstraint.activate([
            eventSourceLabel.topAnchor.constraint(equalTo: eventsNearbyLabel.bottomAnchor),
            eventSourceLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            eventSourceLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
        ])
        
        //Layout Constraints for collectionView
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: eventSourceLabel.bottomAnchor, constant: 16.0),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
        ])
    }
        
    //Calling service method to fetch events based on current location
    private func loadEvents(ll: String) {
        NGAPIService.getEvents(ll: ll) { (success, list) in
            
            if success, let list = list {
                NGDataHelper.shared.eventsList = list
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    print(NGDataHelper.shared.eventsList)
                }
            } else {
                // show no data alert
                self.displayNoDataAlert(title: "We apologize...", message: "Server Error: We could not load any upcoming events.")
            }
            
        }
    }
    
    private func getLatLong() -> String {
        if let latitude = locationService.locationManager.location?.coordinate.latitude, let longitude = locationService.locationManager.location?.coordinate.longitude {
            eventsNearbyLabel.text = "Events Nearby"
            return "\(latitude),\(longitude)"
        } else {
            //Default Location: New York, New York
            eventsNearbyLabel.text = "Events in New York, NY"
            return "40.730610,-73.935242"
        }
    }
    
    private func displayNoDataAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        })
        
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
    
}

extension NGEventsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //How many items/cells to display
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventsDataSource.count
    }
    
    //Returns a new cell with customizations
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Populating cell with place data
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! NGEventListCollectionViewCell
        let event = eventsDataSource[indexPath.item]
        cell.populate(with: event)
        
        return cell
    }
    
}

extension NGEventsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

extension NGEventsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = collectionView.frame.size.width
        return CGSize(width: (w - 20)/2, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
}



