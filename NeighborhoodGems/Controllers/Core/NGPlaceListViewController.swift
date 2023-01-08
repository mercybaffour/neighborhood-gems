//
//  NGPlaceListViewController.swift
//  NeighborhoodGems
//
//  
//

import UIKit
import CoreLocation

class NGPlaceListViewController: UIViewController, CLLocationManagerDelegate {

    //MARK: Management
    ///Provides data to populate our grid view
    var placeDataSource: [NGPlace] {
        return NGDataHelper.shared.placesList
    }
    
    ///Our app displays a list of places nearby based on user's current location. This service serves the user's current and most recent location
    var locationService = NGLocationHelper()
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 32.0)
        label.textAlignment = .center
        label.text = "explore"
        label.textColor = .label
        return label
    }()
    
    private lazy var categorySearchField: UITextField = {
        var textField = UITextField(frame: CGRect(x: 16, y: 200, width: UIScreen.main.bounds.size.width - 32, height: 40))
        textField.setBaseStyling()
        textField.loadDropdown(options: NGDataHelper.shared.categories)
        textField.attributedPlaceholder = NSAttributedString(string: "Search By Category", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        let searchIcon = UIImageView.init(frame: CGRect.init(x: 10, y: 10, width: 20, height: 20))
        searchIcon.image = UIImage.init(systemName: "magnifyingglass")
        searchIcon.tintColor = .black
        searchIcon.layer.cornerRadius = 8.0
        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        leftView.backgroundColor = .clear
        leftView.addSubview(searchIcon)
        textField.leftView = leftView
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var citySearchField: UITextField = {
        var textField = UITextField(frame: CGRect(x: 16, y: 260, width: UIScreen.main.bounds.size.width - 32, height: 40))
        textField.loadDropdown(options: NGDataHelper.shared.cities)
        textField.setBaseStyling()
        textField.attributedPlaceholder = NSAttributedString(string: "Select City Destination", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        let searchIcon = UIImageView.init(frame: CGRect.init(x: 10, y: 10, width: 20, height: 20))
        searchIcon.image = UIImage.init(systemName: "house")
        searchIcon.tintColor = .black
        searchIcon.layer.cornerRadius = 8.0
        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        leftView.backgroundColor = .clear
        leftView.addSubview(searchIcon)
        textField.leftView = leftView
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var submitBtn: UIButton = {
        let btn = UIButton()
        btn.layer.masksToBounds = false
        btn.backgroundColor = .systemOrange
        btn.layer.cornerRadius = 16.0
        btn.setTitle("Search", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(submitBtnPressed), for: .touchUpInside)
        btn.center = self.view.center
        return btn
    }()
    
    private lazy var placesNearbyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 24.0)
        label.textAlignment = .center
        label.textColor = .label
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
        cv.register(NGPlaceListCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return cv
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationService.start()
        hidePickerView()
        setupViews()
        //If location services are authorized, load 'Places Nearby' collection view based on user's current location
        loadData(ll: getLatLong())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Reset values on each view appearance
        hidePickerView()
        categorySearchField.text = nil
        citySearchField.text = nil
    }
}

extension NGPlaceListViewController {
    
    // MARK: User Interaction
    @objc func submitBtnPressed(sender: UIButton!) {
        let categorySearchInput = categorySearchField.text
        let citySearchInput = citySearchField.text
        print("Button pressed, input: \(String(describing: categorySearchInput)), \(String(describing: citySearchInput))")
        
        loadUserResults(term: categorySearchInput!, city: citySearchInput!)
        self.view.endEditing(true)
    }
    
    ///Responds to touch gesture on main view by hiding the dropdown/picker
    private func hidePickerView(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        tap.delegate = self
        //Attach gesture recognizer to main view
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissPicker(){
        self.view.endEditing(true)
    }
    
    //MARK: Location Services
    /// If location services are authorized, this function will get the user's most recent location latitude and longitude, else the default location of New York, NY will be used
    private func getLatLong() -> String {
        if let latitude = locationService.locationManager.location?.coordinate.latitude, let longitude = locationService.locationManager.location?.coordinate.longitude {
            placesNearbyLabel.text = "Places Nearby"
            return "\(latitude),\(longitude)"
        } else {
            //Default Location: New York, New York
            placesNearbyLabel.text = "Centers in New York"
            return "40.730610,-73.935242"
        }
    }
    
     
    // MARK: Setup Views & Layout
    private func setupViews() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(categorySearchField)
        self.view.addSubview(citySearchField)
        self.view.addSubview(submitBtn)
        self.view.addSubview(placesNearbyLabel)
        self.view.addSubview(collectionView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        categorySearchField.translatesAutoresizingMaskIntoConstraints = false
        citySearchField.translatesAutoresizingMaskIntoConstraints = false
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        placesNearbyLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
        ])
         
        
        NSLayoutConstraint.activate([
            categorySearchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),
            categorySearchField.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            categorySearchField.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            citySearchField.topAnchor.constraint(equalTo: categorySearchField.bottomAnchor, constant: 16.0),
            citySearchField.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            citySearchField.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            submitBtn.topAnchor.constraint(equalTo: citySearchField.bottomAnchor, constant: 16.0),
            submitBtn.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            submitBtn.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            placesNearbyLabel.topAnchor.constraint(equalTo: submitBtn.bottomAnchor, constant: 16.0),
            placesNearbyLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            placesNearbyLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: placesNearbyLabel.bottomAnchor, constant: 16.0),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
    }
    
    
    ///API Call to fetch places based on current location
    private func loadData(ll: String) {
        NGAPIService.getPlacesList(term: "Community", ll: ll) { (success, list) in
            
            if success, let list = list {
                NGDataHelper.shared.placesList = list
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } else {
                // show no data alert
                self.displayNoDataAlert(title: "We apologize...", message: "Server Error: No places to display")
            }
            
        }
    }
    
    /// API Call  to fetch place list based on user's search terms: category & city
    private func loadUserResults(term: String, city: String){
        NGAPIService.getUserPlacesList(term: term, city: city) { (success, list) in
            
            if success, let list = list {
                NGDataHelper.shared.searchResultsList = list
                
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(NGResultsListViewController(), animated: true)
                }
            } else {
                // show no data alert
                self.displayNoDataAlert(title: "We apologize...", message: "We have no data for your category and/or city destination search results. Please try again.")
            }
            
        }
    }
    
    /// API Call  to fetch the tips/details for each place
    private func loadPlaceDetail(with place: NGPlace) {
        NGAPIService.getPlaceTips(id: place.fsqId) { (success, response) in
            
            if success, let response = response {
                NGDataHelper.shared.placeTips = response
                
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(NGPlaceDetailViewController(place: place, tips: NGDataHelper.shared.placeTips), animated: true)
                }
            } else {
                
                // show no data alert
                self.displayNoDataAlert(title: "We apologize...", message: "Server Error: We have no details for this place.")
                
            }
        }
    }
    
    //To be used in situations when there are no results coming from external APIs
    private func displayNoDataAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        })
        
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
    
}


extension NGPlaceListViewController: UIGestureRecognizerDelegate {
    /// Recognizes and responds to touch gesture on the main view, but not on child subviews
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //the gestureRcognizer here is attached to the main view
        //returns false if touch.view is not the main view
        return touch.view == gestureRecognizer.view
    }
}

extension NGPlaceListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //How many items/cells to display
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return placeDataSource.count
    }
    
    //Returns a new cell with customizations
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Populating cell with place data
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! NGPlaceListCollectionViewCell
        let place = placeDataSource[indexPath.item]
        cell.populate(with: place)
        
        //Setting cell with place image from Foursquare API. If there's no associated image, a default image will be displayed in this cell
        NGAPIService.getPlaceImage(id: place.fsqId, completion: { (success, imageData) in
            if success, let imageData = imageData,
                let photo = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    cell.setImage(image: photo)
                }
            } else {
                let photoImage = UIImage(named: "mountainsilhouette.jpeg")
                DispatchQueue.main.async {
                    cell.setImage(image: photoImage)
                }
            }
        })
        
        return cell
    }
    
}

/// API Call to fetch place details when cell is selected
extension NGPlaceListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Making API Call to retrieve place detail for this unique cell item
        let place = placeDataSource[indexPath.item]
        self.loadPlaceDetail(with: place)
        
    }
    
}

extension NGPlaceListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = collectionView.frame.size.width
        return CGSize(width: (w - 20)/2, height: 290)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
}

