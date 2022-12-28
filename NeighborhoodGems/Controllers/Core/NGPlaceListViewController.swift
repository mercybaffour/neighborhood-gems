//
//  NGPlaceListViewController.swift
//  NeighborhoodGems
//
//  
//

import UIKit

class NGPlaceListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Do any additional setup after loading the view.
    }
    
    //Calling service method to fetch places list by providing a search term
    func loadData() {
        NGService.getPlacesList(term: "coffee") { (success, list) in
            
            if success, let list = list {
                NGDataManager.shared.placesList = list
                
                print(NGDataManager.shared.placesList)
                
            }
            else {
                // show no data alert
                print("no data")
            }
            
        }
    }
    
    
}
