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
    //Provides data to populate our grid view
    var placeDataSource: [NGPlace] {
        return NGDataManager.shared.placesList
    }
    
    
    let locationManager = CLLocationManager()
    
    var lat_long = ""
    
    // MARK: - UI
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return cv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Explore"
        label.textColor = .white
        return label
    }()
    
    private lazy var categorySearchField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 16, y: 125, width: screenWidth - 32, height: 40))
        textField.backgroundColor = UIColor.init(red: 213.0/255.0, green: 207.0/255.0, blue: 207.0/255.0, alpha: 1)
        textField.layer.masksToBounds = false
        textField.attributedPlaceholder = NSAttributedString(string: "Search By Category", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        textField.layer.shadowRadius = 3.0
        textField.layer.shadowColor = UIColor.init(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 0.3).cgColor
        textField.layer.shadowOffset = CGSize(width: 1, height: 2)
        textField.layer.shadowOpacity = 1.0
        textField.layer.cornerRadius = 8.0
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
        let textField = UITextField(frame: CGRect(x: 16, y: 125, width: screenWidth - 32, height: 120))
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.init(red: 213.0/255.0, green: 207.0/255.0, blue: 207.0/255.0, alpha: 1)
        textField.layer.masksToBounds = false
        textField.attributedPlaceholder = NSAttributedString(string: "Enter City Destination", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        textField.layer.shadowRadius = 3.0
        textField.layer.shadowColor = UIColor.init(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 0.3).cgColor
        textField.layer.shadowOffset = CGSize(width: 1, height: 2)
        textField.layer.shadowOpacity = 1.0
        textField.layer.cornerRadius = 8.0
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
        let btn = UIButton(frame: CGRect(x: 16, y: 125, width: screenWidth - 32, height: 40))
        btn.layer.masksToBounds = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemOrange
        btn.layer.cornerRadius = 16.0
        btn.setTitle("Search", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        btn.center = self.view.center
        return btn
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
        setupViews()
       
    }
    
    
}

extension NGPlaceListViewController {
    
    var screenWidth : CGFloat {
           return UIScreen.main.bounds.size.width
    }
    
    @objc func buttonPressed(sender: UIButton!) {
        let categorySearchInput = categorySearchField.text
        let citySearchInput = citySearchField.text
        print("Button pressed, input: \(String(describing: categorySearchInput)), \(String(describing: citySearchInput))")
        
        loadUserResults(term: categorySearchInput!, city: citySearchInput!)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        lat_long = "\(locValue.latitude),\(locValue.longitude)"
        
        loadData(ll: lat_long)
    }
     
    
    
    private func setupLocation() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.requestAlwaysAuthorization()
                self.locationManager.requestWhenInUseAuthorization()
                
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
            }
        }
    }
     
    
    private func setupViews() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(categorySearchField)
        self.view.addSubview(citySearchField)
        self.view.addSubview(submitBtn)
        self.view.addSubview(collectionView)
        
        
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
        ])
         
        
        NSLayoutConstraint.activate([
            categorySearchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
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
            collectionView.topAnchor.constraint(equalTo: submitBtn.bottomAnchor, constant: 16.0),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
    }
    
    //Calling service method to fetch places based on current location
   func loadData(ll: String) {
        NGService.getPlacesList(term: "art", ll: ll) { (success, list) in
            
            if success, let list = list {
                NGDataManager.shared.placesList = list
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            else {
                // show no data alert
                self.displayNoDataAlert(title: "We apologize...", message: "No places to display =(")
            }
            
        }
    }
    
    //Calling service method to fetch place list based on user's search term and current location
    func loadUserResults(term: String, city: String){
        NGService.getUserPlacesList(term: term, city: city) { (success, list) in
            
            if success, let list = list {
                NGDataManager.shared.placesList = list
                
                DispatchQueue.main.async {
                    print(NGDataManager.shared.placesList)
                }
            }
            else {
                // show no data alert
                self.displayNoDataAlert(title: "We apologize...", message: "No places to display =(")
            }
            
        }
    }
    
    //Calling service method to fetch place tips
    func loadPlaceDetail(with place: NGPlace) {
        NGService.getPlaceTips(id: place.fsq_id) { (success, response) in
            
            if success, let response = response {
                NGDataManager.shared.placeTips = response
                
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(NGPlaceDetailViewController(place: place, tips: NGDataManager.shared.placeTips), animated: true)
                }
            }
            else {
                
                // show no data alert
                self.displayNoDataAlert(title: "We apologize...", message: "No places to display =(")
                
            }
            
        }
    }
    
    private func displayNoDataAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Okay", style: .cancel, handler: { (action) -> Void in
        })
        
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ListCollectionViewCell
        let place = placeDataSource[indexPath.item]
        cell.populate(with: place)
        
        let photoImage = UIImage(named: "mountainsilhouette.jpeg")
        cell.setImage(image: photoImage)
        
        
        /*let imageURL = "https://api.foursquare.com/v3/places/\(place.fsq_id)/photos"
        NGService.getImage(imageUrl: imageURL, completion: { (success, imageData) in
            print("I'm in cell for item at")
            if success, let imageData = imageData,
                let photo = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    cell.setImage(image: photo)
                }
            }
        })
         */
        
        
        return cell
    }
    
}


//Upon cell selection, api call to fetch place details
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



//Cell Prototype
class ListCollectionViewCell: UICollectionViewCell {
    enum Constants {
        static let contentViewCornerRadius: CGFloat = 4.0

        static let imageHeight: CGFloat = 140.0

        static let verticalSpacing: CGFloat = 8.0
        static let horizontalPadding: CGFloat = 16.0
        static let placeVerticalPadding: CGFloat = 80.0
    }
    
    
    var id: String = {
        let id = Int.random(in: 1...10)
        return String(id)
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
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with place: NGPlace) {
        nameLabel.text = place.name
        addressLabel.text = place.location.formatted_address
        self.id = place.fsq_id
    }
     
    func setImage(image: UIImage?) {
         imageView.image = image
    }
    
    
    private func setupViews() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = Constants.contentViewCornerRadius
        contentView.backgroundColor = .systemBackground

        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(addressLabel)
    
    }
    
    private func setupLayouts() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints for imageView
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight)
        ])

        // Layout constraints for nameLabel
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.placeVerticalPadding)
        ])

        // Layout constraints for addressLabel
        NSLayoutConstraint.activate([
            addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6.0)
        ])

    }

 }
 
