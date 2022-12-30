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
        view.backgroundColor = .systemBackground
        setUpTabs()
        
    }
    
    private func setUpTabs() {
        //create instances of view controllers to be attached later
        let placeListVC = NGPlaceListViewController()
        let discoverVC = NGDiscoverViewController()
    

        let nav1 = UINavigationController(rootViewController: placeListVC)
        let nav2 = UINavigationController(rootViewController: discoverVC)
                
        nav1.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "globe"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(systemName: "globe"), tag: 2)
        
        
        //attach view controllers (wrapped in navigation controller) to tab bar controller
        setViewControllers([nav1, nav2], animated: true)
        
    }

}

