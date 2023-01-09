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
        container.backgroundColor = .white
        return container
    }()
     
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .purple
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.text = place!.name
        return label
    }()
     
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.text = place!.location.formattedAddress
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        
        //Assigning label text with ALL tips
        var tipsStr = "Some Tips: \n"
        if let placeTips = tips {
            for tip in placeTips {
                tipsStr += "\(tip.text) \n\n"
            }
        }
        label.text = tipsStr
        
        label.numberOfLines = 16
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
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
        mv.pointOfInterestFilter = MKPointOfInterestFilter(including: []) //show no POI
        return mv
    }()
    
     private lazy var switchLabelView: UILabel = {
        let label = UILabel()
        label.text = "Points of Interest"
        label.textColor = .white
        label.backgroundColor = .darkGray
        return label
    }()
    
    private lazy var switchView: UISwitch = {
        let switcher = UISwitch()
        switcher.isOn = false
        switcher.layer.masksToBounds = true
        switcher.layer.borderColor = UIColor.gray.cgColor
        switcher.layer.borderWidth = 2.0
        switcher.layer.cornerRadius = 15
        switcher.frame = CGRect(x: 100, y: 100, width: 50, height: 40)
        switcher.addTarget(self , action: #selector(didPress), for: .valueChanged)
        return switcher
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupViews()
        setupLayouts()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.scrollView.contentSize.height = self.view.frame.height + 1000
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
    
    //Toggle color change and display of points of interest
    @objc func didPress(sender: UISwitch) {
            switch sender.isOn {
            case true:
                sender.backgroundColor = .green
                let filters = MKPointOfInterestFilter(excluding: []) //explicitly include all POI
                mapView.pointOfInterestFilter = .some(filters)
            case false:
                sender.backgroundColor = .clear
                mapView.pointOfInterestFilter = MKPointOfInterestFilter(including: []) //show no POI
            }
    }
    
    private func setupViews() {
        navigationItem.title = "Place Details"
        
        self.view.addSubview(containerView)
        containerView.addSubview(mapView)
        containerView.addSubview(switchLabelView)
        containerView.addSubview(switchView)
        containerView.addSubview(scrollView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(addressLabel)
        scrollView.addSubview(tipsLabel)
        
    }
    
    private func setupLayouts() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        tipsLabel.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        switchLabelView.translatesAutoresizingMaskIntoConstraints = false
        switchView.translatesAutoresizingMaskIntoConstraints = false
        
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
            mapView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        //Layout constraints for switch label
        NSLayoutConstraint.activate([
            switchLabelView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30.0),
            switchLabelView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 24.0),
            switchLabelView.widthAnchor.constraint(equalToConstant: 130.0)
        ])
        
        //Layout constraints for switch
        NSLayoutConstraint.activate([
            switchView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 25.0),
            switchView.leadingAnchor.constraint(equalTo: switchLabelView.trailingAnchor, constant: 8.0),
            switchView.trailingAnchor.constraint(equalTo: switchLabelView.trailingAnchor, constant: 55.0)
        ])
        
        // Layout constraints for scrollview
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.horizontalPadding),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.horizontalPadding),
            scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
       
        //Set heights for scrollview content
        NSLayoutConstraint.activate([
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            addressLabel.heightAnchor.constraint(equalToConstant: 50),
            tipsLabel.heightAnchor.constraint(equalToConstant: 300),
        ])

        //Set widths for scrollview content
        NSLayoutConstraint.activate([
            nameLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            addressLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            tipsLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        //Set leading and trailing margins for scrollview content
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            tipsLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            tipsLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        ])

        //Set top margins for scrollview content
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8.0),
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20.0),
            tipsLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 20.0),
        ])

        NSLayoutConstraint.activate([
            tipsLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8.0),
        ])

    }
}

extension NGPlaceDetailViewController : MKMapViewDelegate {

}
