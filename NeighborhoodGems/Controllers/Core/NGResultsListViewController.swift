//
//  NGResultsListViewController.swift
//  NeighborhoodGems
//
//  
//

import UIKit

class NGResultsListViewController: UIViewController {
    
    //MARK: Management
    //User's api search results to populate our grid view
    var placeDataSource: [NGPlace] {
        return NGDataHelper.shared.searchResultsList
    }
    
    //Based on this result, our view will show a "no data" alert when false or a collection view when true
    var hasDataSource: Bool = true
    
    // MARK: - UI
    private lazy var neighborhoodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = getTopNeighborhoods()
        label.textAlignment = .center
        label.backgroundColor = .orange
        return label
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: self.view.frame, collectionViewLayout: self.layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.register(NGListCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return cv
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayAlertOnNoPlaceResults()
        setupViews()
    }
    
    
}

extension NGResultsListViewController {
    
    private func setupViews() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.view.addSubview(neighborhoodLabel)
        self.view.addSubview(collectionView)
        
        let margins = view.layoutMarginsGuide
        
        //Layout Constraints for neighborhoodLabel
        NSLayoutConstraint.activate([
            neighborhoodLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            neighborhoodLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            neighborhoodLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
        ])
        
        //Layout Constraints for collectionView
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: neighborhoodLabel.bottomAnchor, constant: 16.0),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
        ])
         
        
       
    }
    
    ///When view loads, if the previous search produces no results, display popup alert
    private func displayAlertOnNoPlaceResults() {
        if placeDataSource.isEmpty {
            hasDataSource = false
            self.displayNoDataAlert(title: "We apologize...", message: "We don't have any data based on your category and/or city destination search. Please try again.")
        }
    }
    
   /// API Call to fetch place details
    private func loadPlaceDetail(with place: NGPlace) {
        NGAPIService.getPlaceTips(id: place.fsq_id) { (success, response) in
            
            if success, let response = response {
                NGDataHelper.shared.placeTips = response
                
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(NGPlaceDetailViewController(place: place, tips: NGDataHelper.shared.placeTips), animated: true)
                }
            }
            else {
                // show no data alert
                self.displayNoDataAlert(title: "We apologize...", message: "We do not have any details for this place.")
            }
        }
    }
    
    private func displayNoDataAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            if self.hasDataSource == false {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
        
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
    
    ///Get most frequent neighborhoods listed in API call (getUserPlacesList)  results
      private func getTopNeighborhoods() -> String {
        //Initialize neighborhood frequency dictionary and result
        var neighborhoodFrequencies: [String: Int] = [:]
        var result = ""
        
        //Add each neighborhood's occurrence to dictionary
        for place in placeDataSource {
            if let neighborhoods = place.location.neighborhood {
                for neighborhood in neighborhoods {
                    neighborhoodFrequencies[neighborhood] = (neighborhoodFrequencies[neighborhood] ?? 0) + 1
                }
            }
        }
        
        //Find most frequent neighborhoods in dictionary using the max, map, and filter methods & store result(s)
        if let topNeighborhoods = neighborhoodFrequencies.values.max()
            .map(
                
                { maxValue in neighborhoodFrequencies.filter { $0.value == maxValue }.map { $0.key } } //filters dictionary based on max value & returns the associated keys in an array
            )
        {
            result = topNeighborhoods.joined(separator: " | ")
        }
        
        return "Top Neighborhood(s): \(result)"
    }
}

extension NGResultsListViewController: UICollectionViewDataSource {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! NGListCollectionViewCell
        let place = placeDataSource[indexPath.item]
        cell.populate(with: place)
        
        //Setting cell with place image from external api, or if there's none, a default image
        NGAPIService.getPlaceImage(id: place.fsq_id, completion: { (success, imageData) in
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


///API  call to fetch place details when cell is selected 
extension NGResultsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Making API Call to retrieve place detail for this unique cell item
        let place = placeDataSource[indexPath.item]
        self.loadPlaceDetail(with: place)
        
    }
    
}

extension NGResultsListViewController: UICollectionViewDelegateFlowLayout {
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




