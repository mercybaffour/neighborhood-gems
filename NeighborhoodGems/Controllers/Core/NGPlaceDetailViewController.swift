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
    var placeId: String!
    private var place: NGPlace?
    
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
         return label
    }()
     
    private lazy var addressLabel: UILabel = {
         let label = UILabel()
         label.backgroundColor = .clear
         label.textColor = .label
         label.numberOfLines = 3
         return label
    }()
    
    private lazy var mapView: MKMapView = {
        let mv = MKMapView()
        return mv
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .systemMint
        mapView.delegate = self
        setupViews()
        setupLayouts()
        
    }
    
}

private extension NGPlaceDetailViewController {
    enum Constants {
        static let screenWidth : CGFloat = UIScreen.main.bounds.size.width
        static let containerHeight : CGFloat = UIScreen.main.bounds.size.height
        static let contentViewCornerRadius: CGFloat = 4.0
        static let imageHeight: CGFloat = 180.0
        static let verticalSpacing: CGFloat = 8.0
        static let horizontalPadding: CGFloat = 16.0
        static let placeVerticalPadding: CGFloat = 8.0
    }
    
    func setupViews() {
        navigationItem.title = "Place Details"
        
        self.view.addSubview(containerView)
        containerView.addSubview(mapView)
        containerView.addSubview(imageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(addressLabel)
        
    
    }
    
    func setupLayouts() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        // Layout constraints for container
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
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
            imageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight)
        ])

        // Layout constraints for nameLabel
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalPadding),
            nameLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.horizontalPadding),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.placeVerticalPadding)
        ])

        // Layout constraints for addressLabel
        NSLayoutConstraint.activate([
            addressLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalPadding),
            addressLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.horizontalPadding),
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6.0)
        ])
        
    }
}

extension NGPlaceDetailViewController : MKMapViewDelegate {

}
