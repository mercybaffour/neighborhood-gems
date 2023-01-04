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
        //Create instances of view controllers to be attached later
        let placeListVC = NGPlaceListViewController()
        let eventsVC = NGEventsViewController()

        let nav1 = UINavigationController(rootViewController: placeListVC)
        let nav2 = UINavigationController(rootViewController: eventsVC)
                
        nav1.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Events", image: UIImage(systemName: "ticket"), tag: 2)
        
        
        //Attach view controllers (wrapped in navigation controller) to tab bar controller
        setViewControllers([nav1, nav2], animated: true)
        
    }

}

