//
//  ViewController.swift
//  NeighborhoodGems
//
//  
//

import UIKit

class NGTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setUpTabs()
        
    }
    
    private func setUpTabs() {
        //create instances of view controllers to be attached later
        let placeListVC = NGPlaceListViewController()
        let resultsVC = NGResultsListViewController()
        let placeDetailVC = NGPlaceDetailViewController()
    

        let nav1 = UINavigationController(rootViewController: placeListVC)
        let nav2 = UINavigationController(rootViewController: resultsVC)
        let nav3 = UINavigationController(rootViewController: placeDetailVC)
                
        nav1.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "globe"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(systemName: "globe"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Place Info", image: UIImage(systemName: "globe"), tag: 3)
        
        
        //attach view controllers (wrapped in navigation controller) to tab bar controller
        setViewControllers([nav1, nav2, nav3], animated: true)
        
    }

}

