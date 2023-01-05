//
//  NGPlaceDetailViewController.swift
//  NeighborhoodGems
//
//  
//

import UIKit
import MapKit

class NGPlaceDetailViewController: UIViewController {

    // MARK: Place Object Details
    private var place: NGPlace?
    
    private var tips: [NGPlaceTip]?
    
    init(place: NGPlace? = nil, tips: [NGPlaceTip]? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.place = place!
        self.tips = tips!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI
    private lazy var containerView: UIView = {
        let container = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Constants.screenWidth - 32, height: Constants.containerHeight))
        container.backgroundColor = .clear
        return container
    }()
    
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
     
     
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .label
        label.text = place!.name
        return label
    }()
     
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .label
        label.text = place!.location.formatted_address
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .label
        
        //Assigning label text with ALL tips
        var tipsStr = ""
        for tip in tips! {
            tipsStr += "\(tip.text) \n"
        }
        label.text = tipsStr
        
        label.numberOfLines = 3
        return label
    }()
    
    
    private lazy var mapView: MKMapView = {
        let mv = MKMapView()
        let center = CLLocationCoordinate2D(latitude: place!.geocodes.main.latitude, longitude: place!.geocodes.main.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "\(place!.name)"
        let coordinateRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        mv.setRegion(coordinateRegion, animated: true)
        mv.addAnnotation(annotation)
        return mv
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupViews()
        setupLayouts()
        
    }
    
}

private extension NGPlaceDetailViewController {
    //Constants for layout constraints
    enum Constants {
        static let screenWidth : CGFloat = UIScreen.main.bounds.size.width
        static let containerHeight : CGFloat = UIScreen.main.bounds.size.height
        static let contentViewCornerRadius: CGFloat = 4.0
        static let imageHeight: CGFloat = 180.0
        static let verticalSpacing: CGFloat = 8.0
        static let horizontalPadding: CGFloat = 16.0
        static let placeVerticalPadding: CGFloat = 8.0
    }
    
    private func setupViews() {
        navigationItem.title = "Place Details"
        
        self.view.addSubview(containerView)
        containerView.addSubview(mapView)
        containerView.addSubview(imageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(addressLabel)
        containerView.addSubview(tipsLabel)
        
    }
    
    private func setupLayouts() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        tipsLabel.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = view.layoutMarginsGuide
        
        // Layout constraints for container
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
      
        // Layout constraints for map
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: containerView.topAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 200.0),
            mapView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8.0),
            mapView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 8.0)
        ])
        
        // Layout constraints for imageView
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight)
        ])

        // Layout constraints for nameLabel
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.placeVerticalPadding),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.horizontalPadding),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.horizontalPadding)
            
        ])

        // Layout constraints for addressLabel
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6.0),
            addressLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.horizontalPadding),
            addressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.horizontalPadding),
           
        ])
        
        // Layout constraints for tipsLabel
        NSLayoutConstraint.activate([
            tipsLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 16.0),
            tipsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.horizontalPadding),
            tipsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.horizontalPadding),
        ])
    }
}

extension NGPlaceDetailViewController : MKMapViewDelegate {

}
