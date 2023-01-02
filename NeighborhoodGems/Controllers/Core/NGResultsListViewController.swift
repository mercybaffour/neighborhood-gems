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
        return NGDataManager.shared.searchResultsList
    }
    
    var userResultsHasLoaded: Bool
    
    init(userResultsHasLoaded: Bool) {
        self.userResultsHasLoaded = userResultsHasLoaded
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    private lazy var neighborhoodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No results so far"
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
        let cv = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userResultsHasLoaded {
            neighborhoodLabel.text = getTopNeighborhoods()
        }
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
        
        NSLayoutConstraint.activate([
            neighborhoodLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            neighborhoodLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            neighborhoodLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: neighborhoodLabel.bottomAnchor, constant: 16.0),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
        ])
         
        
       
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
    
    private func getTopNeighborhoods() -> String {
        var neighborhoodFrequencies: [String: Int] = [:]
        var result = ""
        
        for place in placeDataSource {
            let neighborhood = place.location.neighborhood[0]
            neighborhoodFrequencies[neighborhood] = (neighborhoodFrequencies[neighborhood] ?? 0) + 1
        }
        
        if let topNeighborhoods = neighborhoodFrequencies.values.max()
            .map({ maxFrequency in neighborhoodFrequencies.filter { $0.value == maxFrequency }.map { $0.key } }) {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ListCollectionViewCell
        let place = placeDataSource[indexPath.item]
        cell.populate(with: place)
        
        let photoImage = UIImage(named: "mountainsilhouette.jpeg")
        cell.setImage(image: photoImage)
        
        return cell
    }
    
}


//Upon cell selection, api call to fetch place details
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




